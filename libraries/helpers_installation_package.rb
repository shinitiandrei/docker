module DockerCookbook
  module DockerHelpers
    module InstallationPackage
      def el6?
        return true if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6
        false
      end

      def el7?
        return true if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 7
        false
      end

      def fedora?
        return true if node['platform'] == 'fedora'
        false
      end

      def wheezy?
        return true if node['platform'] == 'debian' && node['platform_version'].to_i == 7
        false
      end

      def jesse?
        return true if node['platform'] == 'debian' && node['platform_version'].to_i == 8
        false
      end

      def precise?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '12.04'
        false
      end

      def trusty?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
        return true if node['platform'] == 'linuxmint' && node['platform_version'] =~ /^17\.[0-9]$/
        false
      end

      def vivid?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '15.04'
        false
      end

      def wily?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '15.10'
        false
      end

      def xenial?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
        false
      end

      def amazon?
        return true if node['platform'] == 'amazon'
        false
      end

      def suse?
        return true if node['platform'] == 'suse' && node['platform_version'] == '12.1'
        false
      end

      # https://github.com/chef/chef/issues/4103
      def version_string(v)
        return "#{v}-1.el6" if el6?
        return "#{v}-1.el7.centos" if el7?
        return "#{v}-1.el6" if amazon?
        return "#{v}-1.fc#{node['platform_version'].to_i}" if fedora?
        return "#{v}-0~wheezy" if wheezy?
        return "#{v}-0~jessie" if jesse?
        return "#{v}-0~precise" if precise?
        return "#{v}-0~trusty" if trusty?
        return "#{v}-0~vivid" if vivid?
        return "#{v}-0~wily" if wily?
        return "#{v}-0~xenial" if xenial?
      end

      def default_docker_version
        return '1.7.1' if el6?
        return '1.7.1' if amazon?
        return '1.8.3' if suse?
        return '1.9.1' if vivid?
        '1.11.2'
      end

      def docker_bin
        '/usr/bin/docker'
      end
    end
  end
end
