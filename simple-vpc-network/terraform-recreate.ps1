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

function terraform_providers_versions() {
    Write-Host "Here is your configuration required providers and versions" -ForegroundColor Green
    terraform providers 2>&1 | Tee-Object -FilePath "$PWD/logs/provider_tree.txt"
    prev_command_exit_status $LASTEXITCODE "prviders"
    terraform versions -v 2>&1 | Tee-Object -FilePath "$PWD/logs/providers_versions.txt"
    prev_command_exit_status $LASTEXITCODE "versions -v"
}

function initialize_terraform()
{
    Write-Host "Initializing Terraform: >terraform init" -ForegroundColor Green
    terraform get -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/get_log.txt"
    prev_command_exit_status $LASTEXITCODE "get"
    terraform init -upgrade -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/init_log.txt"
    prev_command_exit_status $LASTEXITCODE "init"
}

function format_tf_config_files()
{
    Write-Host "Formatting the files: >terraform fmt" -ForegroundColor Blue
    terraform fmt -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/fmt_log.txt"
    prev_command_exit_status $LASTEXITCODE "fmt"
}

function validate_the_tf_configs()
{
    Write-Host "Validating the TF config: >terraform validate" -ForegroundColor Blue
    terraform validate -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/validate_log.txt"
    prev_command_exit_status $LASTEXITCODE "validate"
}

function destroy_old_provisioned_resources()
{
    Write-Host "Do you want to destory old resources: >terraform destroy -auto-approve" -ForegroundColor Yellow
    $destroy = Read-Host -Prompt "Select Y/y for yes else press any key?(Y/N)"
    if ($destroy -eq 'Y')
    {
        Write-Host "terraform destroying all old resources please wait" -ForegroundColor Red
        terraform destroy -auto-approve -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/destroy_log.txt" #-lock=false # need to remove -lock=false
        prev_command_exit_status $LASTEXITCODE "destroy"
    }
    else
    {
        Write-Host "Skipped >terraform destroy" -ForegroundColor Red
    }
}

function plan_infra()
{
    Write-Host "Showing the plan for configurations: >terraform plan" -ForegroundColor Green
    terraform plan -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/plan_log.txt"# need to remove -lock=false
    prev_command_exit_status $LASTEXITCODE "plan"
}

function create_infra()
{
    $planapply = Read-Host -Prompt "Do you want to apply the changes? Y/N"
    if ($planapply -eq 'Y')
    {
        Write-Host "terraform Apply running: >terraform apply -auto-approve" -ForegroundColor Green
        terraform apply -auto-approve -no-color 2>&1 | Tee-Object -FilePath "$PWD/logs/apply_log.txt"#-lock=false
        prev_command_exit_status $LASTEXITCODE "apply"
        Write-Host "Saving output: >terraform output > output.txt" -ForegroundColor Green
        terraform output > output.txt
        prev_command_exit_status $LASTEXITCODE "output > output.txt"
    }
    else
    {
        Write-Host "terraform Apply skipped" -ForegroundColor Red
    }
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
    initialize_terraform
    terraform_providers_versions
    format_tf_config_files
    validate_the_tf_configs
    destroy_old_provisioned_resources
    plan_infra
    create_infra
    Write-Host "####-----TERRAFORM FINISHED ALL PROCESSSES-----####" -ForegroundColor Green
    state_managed_resources
}

exec_main