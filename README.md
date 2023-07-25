# Arch Linux configuration with Ansible

This project uses Ansible and Docker to automate the installation of packages and the application of dotfiles on an Arch Linux system.

## How to Use This Project

### Prerequisites

- Docker
- Ansible
- git

### Instructions

1. Clone this repository to your local machine: `git clone https://github.com/cmoron/arch_setup.git`.

2. Navigate to the project directory: `cd arch_setup`.

3. Run the package installation playbook: `ansible-playbook install_packages.yml`.

4. Run the playbook to apply the dotfiles: `ansible-playbook apply_dotfiles.yml`.

This will install all necessary packages and apply dotfiles from the specified git repository.

## Testing

To test this project, we use Docker. Follow the steps below to run the tests:

1. Ensure the Docker service is running on your machine.

2. Run the test script: `./test.sh`.

The script will create a Docker container, run the Ansible playbooks inside it, and verify that all packages are installed correctly and that the dotfiles are applied correctly.

## Notes

- Make sure you have the necessary permissions to run the playbooks and the test script.
- If you are running the playbooks on your main system, make sure you understand what each task does. It's recommended to first test in a test environment or a virtual machine.
