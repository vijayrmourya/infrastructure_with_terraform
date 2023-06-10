function decorate($operation, $color)
{
    Write-Host ("{0} {1}" -f (">"*3), $operation) -ForegroundColor $color
    Write-Host ("+"*100) -ForegroundColor $color
}

function prev_command_exit_status($status, $command)
{
    if ($status -eq 0)
    {
        decorate "terraform $command : executed successfully" "Green"
    }
    else
    {
        decorate "terraform $command : FAILED" "Red"
        exit 0
    }
}

function setup_log_trace()
{
    #    $Env:TF_LOG = "TRACE"
    $Env:TF_LOG = ""
}

function display_infra()
{
    decorate "Showing all provisioned resources: >terraform show" "Blue"
    terraform show
    prev_command_exit_status $LASTEXITCODE "show"
}

function state_managed_resources()
{
    decorate "listing the resources under state file:" "Blue"
    terraform state list | Tee-Object -FilePath "$PWD/resources.txt"
    prev_command_exit_status $LASTEXITCODE "state list"
}

function destroy_all_provisioned_resources()
{
    decorate "Do you want to destory all resources: >terraform destroy -auto-approve" "Red"
    $destroy = Read-Host -Prompt "Select Y/y for yes else press any key?(Y/N)"
    if ($destroy -eq 'Y')
    {
        decorate "terraform destroying all resources please wait" "Red"
        terraform destroy --auto-approve -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/destroy_log.txt" #-lock=false # need to remove -lock=false
        prev_command_exit_status $LASTEXITCODE "destroy"
    }
    else
    {
        decorate "Skipped >terraform destroy" "Green"
    }
}

function exec_main()
{
    if (-not(Test-Path "$PWD/logs"))
    {
        New-Item -ItemType Directory -Path "$PWD/logs"
    }
    setup_log_trace
    display_infra
    state_managed_resources
    destroy_all_provisioned_resources
    decorate "all terraform operations completed" "Green"
}

exec_main