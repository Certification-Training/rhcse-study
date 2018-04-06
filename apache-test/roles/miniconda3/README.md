Install Miniconda3 (read-only) at a system level and give users PATH access to it

## Role Dependencies

None

## File Dependencies

None

## Usage

```yaml
  - name: Install miniconda
    become: true
    include_role:
      name: miniconda3
    vars:
      miniconda3_install_dir: '/opt/miniconda3'
      miniconda3_users_with_bash_help:
        - "{{ main_automation_username }}"
```
