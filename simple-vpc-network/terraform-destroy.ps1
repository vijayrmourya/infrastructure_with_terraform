function decorate($operation, $color)
{
    Write-Host ("{0} {1}" -f (">"*3), $operation) -ForegroundColor $color
    Write-Host ("+"*100) -ForegroundColor $color
}

function prev_command_exit_status($status, $command)
{
    if ($status -eq 0)
    {
        decorate "terraform $command | <STATUS><SUCCESS>" "Green"
    }
    else
    {
        decorate "terraform $command | <STATUS><FAILED>" "Red"
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
    decorate "terraform show | Showing all provisioned resources in detail" "Blue"
    terraform show
    prev_command_exit_status $LASTEXITCODE "show"
}

function state_managed_resources()
{
    decorate "terraform state list | listing all the resources under current config state file(if any)" "Blue"
    terraform state list | Tee-Object -FilePath "$PWD/resources.txt"
    prev_command_exit_status $LASTEXITCODE "state list"
}

function destroy_all_provisioned_resources()
{
    decorate "terraform destroy --auto-approve | Do you want to destory all resources" "Red"
    $destroy = Read-Host -Prompt "Select Y/y for yes else press any key?(Y/N)"
    if ($destroy -eq 'Y')
    {
        decorate "terraform destroying all resources please wait.........." "Red"
        terraform destroy --auto-approve -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/destroy_log.txt" #-lock=false # need to remove -lock=false
        prev_command_exit_status $LASTEXITCODE "destroy"
    }
    else
    {
        decorate "terraform destroy | <SKIPPED>" "Green"
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