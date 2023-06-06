function setup_log_trace()
{
#    $Env:TF_LOG = "TRACE"
    $Env:TF_LOG = ""
}

function prev_command_exit_status($status, $command)
{
    if ($status -eq 0)
    {
        Write-Host "terraform $command : executed successfully" -ForegroundColor Green
    }
    else
    {
        Write-Host "terraform $command : FAILED" -ForegroundColor Red
        exit 0
    }
}

function destroy_all_provisioned_resources()
{
    state_managed_resources
    Write-Host "Do you want to destory all resources: >terraform destroy -auto-approve" -ForegroundColor Yellow
    $destroy = Read-Host -Prompt "Select Y/y for yes else press any key?(Y/N)"
    if ($destroy -eq 'Y')
    {
        Write-Host "terraform destroying all old resources please wait" -ForegroundColor Red
        setup_log_trace
        terraform destroy -auto-approve -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/destroy_log.txt" #-lock=false # need to remove -lock=false
        prev_command_exit_status $LASTEXITCODE "destroy"
    }
    else
    {
        Write-Host "Skipped >terraform destroy" -ForegroundColor Red
    }
}

function display_infra()
{
    Write-Host "Showing all provisioned resources: >terraform show" -ForegroundColor Yellow
    terraform show
    prev_command_exit_status $LASTEXITCODE "show"
}

function state_managed_resources(){
    terraform state list | Tee-Object -FilePath "$PWD/resources.txt"
}

function exec_main()
{
    if (-not (Test-Path "$PWD/logs")) {
        New-Item -ItemType Directory -Path "$PWD/logs"
    }
    Write-Host "SETTING LOG TRACE" -ForegroundColor Green
    setup_log_trace
    Write-Host "####-----TERRAFORM STARTING ALL PROCESSSES-----####" -ForegroundColor Green
    display_infra
    destroy_all_provisioned_resources
    Write-Host "####-----TERRAFORM FINISHED ALL PROCESSSES-----####" -ForegroundColor Green
}

exec_main