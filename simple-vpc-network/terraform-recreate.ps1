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

function initialize_terraform()
{
    decorate "terraform init | Initializing Terraform as per configurations" "Blue"
    terraform get -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/get_log.txt"
    prev_command_exit_status $LASTEXITCODE "get"
    terraform init -upgrade -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/init_log.txt"
    prev_command_exit_status $LASTEXITCODE "init"
}

function terraform_providers_versions()
{
    decorate "terraform providers | provider configuration tree and required providers configured with their required versions settings" "Blue"
    terraform providers
    prev_command_exit_status $LASTEXITCODE "prviders"
    decorate "terraform versions -v | installed providers list with versions installed" "Blue"
    terraform versions -v 2>&1 | Tee-Object -FilePath "$PWD/logs/providers_versions.txt"
    prev_command_exit_status $LASTEXITCODE "versions -v"
}

function format_tf_config_files()
{
    decorate "terraform fmt | ReForming/prettifying the files" "Blue"
    terraform fmt -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/fmt_log.txt"
    prev_command_exit_status $LASTEXITCODE "fmt"
}

function validate_the_tf_configs()
{
    decorate "terraform validate | Validating the terraform configuration code" "Blue"
    terraform validate -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/validate_log.txt"
    prev_command_exit_status $LASTEXITCODE "validate"
}

function state_managed_resources()
{
    decorate "terraform state list | listing all the resources under current config state file(if any)" "Blue"
    terraform state list | Tee-Object -FilePath "$PWD/resources.txt"
    prev_command_exit_status $LASTEXITCODE "state list"
}

function destroy_old_provisioned_resources()
{
    decorate "terraform destroy --auto-approve | Do you want to destory old resources" "Red"
    $destroy = Read-Host -Prompt "Select Y/y for yes else press any key?(Y/N)"
    if ($destroy -eq 'Y')
    {
        decorate "terraform destroying all old resources please wait.........." "Red"
        terraform destroy --auto-approve -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/destroy_log.txt" #-lock=false # need to remove -lock=false
        prev_command_exit_status $LASTEXITCODE "destroy"
    }
    else
    {
        decorate "terraform destroy | <SKIPPED>" "Green"
    }
}

function plan_infra()
{
    decorate "terraform plan | Showing the plan for configurations" "Green"
    terraform plan -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/plan_log.txt"
    prev_command_exit_status $LASTEXITCODE "plan"
}

function create_infra()
{
    $planapply = Read-Host -Prompt "Do you want to apply the changes? Y/N"
    if ($planapply -eq 'Y')
    {
        decorate "terraform apply --auto-approve | creaing the planned resources! please wait........" "Red"
        terraform apply --auto-approve -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/apply_log.txt"
        prev_command_exit_status $LASTEXITCODE "apply"
        decorate "terraform output > output.txt | Saving outputs to output.txt" "Green"
        terraform output > output.txt
        prev_command_exit_status $LASTEXITCODE "output > output.txt"
    }
    else
    {
        decorate "terraform Apply <SKIPPED>" "Red"
    }
}

function exec_main()
{
    if (-not(Test-Path "$PWD/logs"))
    {
        New-Item -ItemType Directory -Path "$PWD/logs"
    }
    setup_log_trace
    initialize_terraform
    terraform_providers_versions
    format_tf_config_files
    validate_the_tf_configs
    state_managed_resources
    destroy_old_provisioned_resources
    plan_infra
    create_infra
    state_managed_resources
    decorate "all terraform operations completed" "Green"
}

exec_main