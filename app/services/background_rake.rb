class BackgroundRake
  class << self
    def call_rake(task, options = {})
      options = options.with_indifferent_access
      options[:rails_env] = Rails.env
      args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
      system "#{Rails.root}/bin/rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
    end
  end
end
