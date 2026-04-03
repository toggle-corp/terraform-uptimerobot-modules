# Terraform UptimeRobot Modules

Opinionated Terraform wrapper modules for managing [UptimeRobot](https://uptimerobot.com/) resources efficiently.

## Setup

> [!NOTE]
> This is an example setup. Adjust paths, module names, and versions according to your project needs.

### Folder Structure

Recommended folder structure:

```bash
terraform
├── monitors_toggle.tf
└── toggle
    ├── modules
    │   ├── cron_monitor
    │   └── http_monitor
    └── README.md
```

### Add Submodules

```bash
mkdir terraform

git submodule add \
    git@github.com:toggle-corp/fugit.git \
    fugit

git submodule add \
    git@github.com:toggle-corp/terraform-uptimerobot-modules.git \
    terraform/toggle
```

### Configure Submodule Branches

Update your `.gitmodules` file to use specific tagged branches:

```gitconfig
# Sync this with ./fugit/scripts/sub-module-sync.sh
[submodule "terraform/toggle"]
    path = terraform/toggle
    url = git@github.com:toggle-corp/terraform-uptimerobot-modules.git
    branch = v0.1.0

[submodule "fugit"]
    path = fugit
    url = git@github.com:toggle-corp/fugit.git
    branch = v0.1.3
```

> [!IMPORTANT]
> Replace `v0.1.0` and `v0.1.3` with the latest release tags from the respective repositories:
>
> - https://github.com/toggle-corp/terraform-uptimerobot-modules/releases
> - https://github.com/toggle-corp/fugit/releases

### Sync Submodules

```bash
./fugit/scripts/sub-module-sync.sh
```

Add and commit your submodule setup.

## Usage

### Example: HTTP Monitor

Create a monitor in `monitors_toggle.tf`:

```hcl
module "monitor_toggle_website_prod" {
  source = "./toggle/modules/http_monitor"

  name  = "Togglecorp"
  url   = "https://togglecorp.com"
  tags  = ["prod"]

  assigned_alert_contacts = [
    local.toggle_email_id,
    local.thenav56_iphone_id,
    uptimerobot_integration.toggle_uptime_alerts.id,
  ]
}
```
