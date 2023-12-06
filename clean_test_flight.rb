require 'fastlane/action'
require_relative '../helper/tomass_helper'

# 在我的 iMac 上
# 在 Clean/fastlane-plugin-tomass 目录下运行
# bundle exec fastlane run tomass


# 在我的 MacBook 上
# 在 Clean 目录下运行
# fastlane run tomass

module Fastlane
  module Actions
    class TomassAction < Action
      def self.run(params)
        require 'spaceship'
        require 'time'

=begin
  <Spaceship::ConnectAPI::BetaGroup:0x000000012af72d00 @id="c99c1c85-f00e-479f-ab80-63037c57eea3", @name="AppStoreConnectUsers", @created_date="2022-04-08T06:52:08.788Z", @is_internal_group=true, @public_link_enabled=nil, @public_link_id=nil, @public_link_limit_enabled=nil, @public_link_limit=nil, @public_link=nil
=end

=begin
  <Spaceship::ConnectAPI::BetaTester:0x0000000103c7b948 @id="80313518-c7e4-4b3b-9629-be4cb5823ec5", @first_name="Anonymous", @last_name=nil, @email=nil, @invite_type="PUBLIC_LINK", @invitation="Public Link", @beta_groups=[#<Spaceship::ConnectAPI::BetaGroup:0x0000000103c7b088 @id="bcc0739f-f066-4d6a-9e9e-ca100c6a360e", @name="外部用户_1000", @created_date="2022-10-31T05:39:47.58Z", @is_internal_group=false, @public_link_enabled=true, @public_link_id="406CXlN8", @public_link_limit_enabled=true, @public_link_limit=1000, @public_link="https://testflight.apple.com/join/406CXlN8">], @beta_tester_metrics=[#<Spaceship::ConnectAPI::BetaTesterMetric:0x0000000103c7a480 @id="80313518-c7e4-4b3b-9629-be4cb5823ec5:1618175312", @install_count=1, @crash_count=0, @session_count=5, @beta_tester_state="INSTALLED", @last_modified_date="2022-11-03T22:11:26.074-07:00", @installed_cf_bundle_short_version_string="0.9.0", @installed_cf_bundle_version="266">
=end

        # app_identifier = params[:app_identifier]
        # username = params[:username]
        app_identifier = "com.tencent.wetype"
        username = "tomasszhang@tencent.com"
        groupLinkId_100 = "nOMDDKRc"
        groupLinkId_1000 = "406CXlN8"
        groupLinkId_7000 = "iSTXkF4K"

        # 一小时没安装就删
        passTime = 3600

        Spaceship::Tunes.login(username)
        Spaceship::Tunes.select_team
        UI.message("Login successful")

        spaceship_app ||= Spaceship::ConnectAPI::App.find(app_identifier)
        UI.user_error!("Couldn't find app '#{app_identifier}' on the account of '#{username}' on iTunes Connect") unless spaceship_app
        
        # 所有测试组
        all_groups = spaceship_app.get_beta_groups(includes: "betaTesters")
        # groupCount = all_groups.count;
        # # print("groupCount #{groupCount}\n")
        groupToFind_100 = nil
        groupToFind_1000 = nil
        groupToFind_7000 = nil
        
        all_groups.each do |current_group|
          if (current_group.public_link_id != nil && current_group.public_link_id[groupLinkId_100])
            groupToFind_100 = current_group
          elsif (current_group.public_link_id != nil && current_group.public_link_id[groupLinkId_1000])
            groupToFind_1000 = current_group
          elsif (current_group.public_link_id != nil && current_group.public_link_id[groupLinkId_7000])
            groupToFind_7000 = current_group
          end
        end

        print("\n")
        print("group_name_100 #{groupToFind_100.instance_variables}\n");
        print("group_name_100 #{groupToFind_100.name}\n");
        print("group_public_link_100 #{groupToFind_100.public_link}\n");
        print("group_public_link_limit_100 #{groupToFind_100.public_link_limit}\n");

        print("\n")

        print("group_name_1000 #{groupToFind_1000.instance_variables}\n");
        print("group_name_1000 #{groupToFind_1000.name}\n");
        print("group_public_link_1000 #{groupToFind_1000.public_link}\n");
        print("group_public_link_limit_1000 #{groupToFind_1000.public_link_limit}\n");
        
        print("\n")
        
        print("group_name_7000 #{groupToFind_7000.instance_variables}\n");
        print("group_name_7000 #{groupToFind_7000.name}\n");
        print("group_public_link_7000 #{groupToFind_7000.public_link}\n");
        print("group_public_link_limit_7000 #{groupToFind_7000.public_link_limit}\n");

        # print("\n")
        # 这吊毛不准，就很奇怪
        # all_testers = groupToFind_100.beta_testers
        # groupTesterCount = all_testers.count
        # print("groupTesterCount #{groupTesterCount}\n")
        
        # 所有测试用户
        print("============ get all testers ============\n")
        all_testers = spaceship_app.get_beta_testers(includes: "betaTesterMetrics,betaGroups")
        print("all testers count #{all_testers.count}\n");
        group_testers_100 = []
        group_testers_1000 = []
        group_testers_7000 = []

        print("============ puck current group users ============\n")
        all_testers.each do |current_tester|
          # print("current_tester #{current_tester.instance_variables}\n")
          if current_tester.beta_groups.count != 1
            next
          end
          beta_group = current_tester.beta_groups.first
          # print("beta_group #{beta_group.instance_variables}\n")
          if beta_group.public_link_id == nil
            next
          end
          if (beta_group.public_link_id[groupLinkId_100])
            group_testers_100.push(current_tester)
          elsif (beta_group.public_link_id[groupLinkId_1000])
            group_testers_1000.push(current_tester)
          elsif (beta_group.public_link_id[groupLinkId_7000])
            group_testers_7000.push(current_tester)
          end
        end

        group_testers = group_testers_100 + group_testers_1000 + group_testers_7000;
        print("group_testers_100 testers count #{group_testers_100.count}\n");
        print("group_testers_1000 testers count #{group_testers_1000.count}\n");
        print("group_testers_7000 testers count #{group_testers_7000.count}\n");
        print("group_testers testers count #{group_testers.count}\n");

        print("\n")
        
        print("============ useless_testers ============\n")
        uninstalled_testers = []
        old_version_testers = []
        new_version_testers = []
        new_version = "1.2.1"
        # now_date = Time.now
        group_testers.each do |current_tester|
          # last_modified_date = Time.parse(tester_metrics.last_modified_date)
          tester_metrics = current_tester.beta_tester_metrics.first
          if tester_metrics == nil
            next
          end
          installed_short_version = tester_metrics.installed_cf_bundle_short_version_string
          installed_bundle_version = tester_metrics.installed_cf_bundle_version
          # print("installed_short_version #{installed_short_version}\n")
          # print("installed_bundle_version #{installed_bundle_version}\n")
          # installed_short_version == "1.1.1" && installed_bundle_version == "336" &&
          if (tester_metrics.beta_tester_state == "INSTALLED")
            if (installed_short_version == new_version)
              new_version_testers.push(current_tester)
            else
              old_version_testers.push(current_tester)
            end
          else
            uninstalled_testers.push(current_tester)
          end
          # time_diff = now_date - last_modified_date
          # if (tester_metrics.beta_tester_state == "INVITED" || tester_metrics.beta_tester_state == "ACCEPTED") && (time_diff > passTime)
          #   self.printTester(current_tester, now_date)
          #   uninstalled_testers.push(current_tester)
          # elsif (tester_metrics.beta_tester_state == "INSTALLED" && (tester_metrics.session_count <= 0 || tester_metrics.install_count <= 0))
          #   self.printTester(current_tester, now_date)
          #   unused_testers.push(current_tester)
          # end
        end

        print("uninstalled testers count #{uninstalled_testers.count}\n");
        print("old version testers count #{old_version_testers.count}\n");
        print("new version #{new_version} testers count #{new_version_testers.count}\n");
        
        print("============ cleanStart ============\n")

        # uninstalled_testers.each do |current_tester|
        #   current_tester.delete_from_apps(apps: [spaceship_app])
        #   print("remove email '#{current_tester.email}' first_name '#{current_tester.first_name}' last_name '#{current_tester.last_name}' success\n")
        # end

        cleaned_count = 0;

        unused_testers = uninstalled_testers + old_version_testers

        print("unused_testers #{unused_testers.count}\n");

        exit 0

        print("============ cleanStart test 1============\n")
        unused_testers.each do |current_tester|
          current_tester.delete_from_apps(apps: [spaceship_app])
          print("remove email '#{current_tester.email}' first_name '#{current_tester.first_name}' last_name '#{current_tester.last_name}' success\n")
          cleaned_count = cleaned_count + 1;
        end
        
        print("============ cleanEnd ============\n")

        print("unused_testers #{unused_testers.count}\n");
        print("cleaned_count #{cleaned_count}\n");
      end

      def self.printTester(tester, now_date)
        tester_metrics = tester.beta_tester_metrics.first
        print("first_name #{tester.first_name}\n");
        print("last_name #{tester.last_name}\n");
        print("email #{tester.email}\n");
        print("group_name #{tester.beta_groups.first.name}\n");
        print("group_public_link #{tester.beta_groups.first.public_link}\n");
        print("invite_type '#{tester.invite_type}'\n")
        print("beta_tester_state '#{tester_metrics.beta_tester_state}'\n")
        print("install_count '#{tester_metrics.install_count}'\n")
        print("session_count '#{tester_metrics.session_count}'\n")
        last_modified_date = Time.parse(tester_metrics.last_modified_date)
        print("last_modified_date '#{tester_metrics.last_modified_date}'\n")
        print("last_modified_date_beijing #{last_modified_date.localtime("+08:00")}\n");
        print("now_date #{now_date.to_s}\n")
        print("passed_time #{now_date - last_modified_date}\n")
        print("installed_version #{installed_cf_bundle_short_version_string}\n")
        print("============\n")
      end

      def self.description
        "clean inactive testers"
      end

      def self.authors
        ["tomasszhang"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "clean inactive testers"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "TOMASS_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
