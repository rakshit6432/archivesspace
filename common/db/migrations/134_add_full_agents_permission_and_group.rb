require_relative 'utils'

Sequel.migration do
  $stderr.puts("Creating Permission and Group for Show Full Agents")

  up do
    show_full_agents_permission_id = self[:permission]
    	.insert(:permission_code => 'show_full_agents',
              :description => 'The ability to add and edit extended agent attributes',
              :level => 'global',
              :created_by => 'admin',
              :last_modified_by => 'admin',
              :create_time => Time.now,
              :system_mtime => Time.now,
              :user_mtime => Time.now)
  end

  down do
  end

end

