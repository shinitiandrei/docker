module DockerCookbook
  class DockerServiceManagerSysvinitRhel < DockerServiceBase
    resource_name :docker_service_manager_sysvinit_rhel

    provides :docker_service_manager, platform: 'amazon'
    provides :docker_service_manager, platform: 'suse'
    provides :docker_service_manager, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
      node['platform_version'].to_f <= 7.0
    end

    provides :docker_service_manager_sysvinit, platform: 'amazon'
    provides :docker_service_manager_sysvinit, platform: 'suse'
    provides :docker_service_manager_sysvinit, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
      node['platform_version'].to_f <= 7.0
    end

    action :start do
      create_docker_wait_ready
      create_init
      create_service
    end

    action :stop do
      create_init
      s = create_service
      s.action :stop
    end

    action :restart do
      action_stop
      action_start
    end

    action :enable do
      action_enable
    end

    action_class.class_eval do
      def action_enable
        execute 'enable docker on suse' do
          command 'sudo systemctl enable docker'
          only_if 'zypper products -i | grep SUSE'
          action :run
        end
      end

      def create_init
        execute 'groupadd docker' do
          not_if 'getent group docker'
          action :run
        end

        link "/usr/bin/#{docker_name}" do
          to '/usr/bin/docker'
          link_type :hard
          action :create
          not_if { docker_name == 'docker' }
        end

        template "/etc/init.d/#{docker_name}" do
          source 'sysvinit/docker-rhel.erb'
          owner 'root'
          group 'root'
          mode '0755'
          variables(
            docker_name: docker_name,
            docker_daemon_arg: docker_daemon_arg,
            docker_wait_ready: "#{libexec_dir}/#{docker_name}-wait-ready"
          )
          cookbook 'docker'
          action :create
        end

        template "/etc/sysconfig/#{docker_name}" do
          source 'sysconfig/docker.erb'
          variables(
            config: new_resource,
            docker_daemon_opts: docker_daemon_opts.join(' ')
          )
          cookbook 'docker'
          notifies :restart, new_resource, :immediately
          action :create
        end
      end

      def create_service
        service docker_name do
          supports restart: true, status: true
          action [:enable, :start]
        end
      end
    end
  end
end
