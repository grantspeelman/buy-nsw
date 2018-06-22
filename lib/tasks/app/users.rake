namespace :app do
  namespace :users do
    task "Give a user the admin role"
    task :make_admin, [:email] => :environment do |t, args|
      make_admin(args[:email])
    end

    def make_admin(email)
      user = User.find_by_email(email)

      if user.present?
        user.roles << 'admin'

        if user.save
          puts "#{email}: " + "User role updated to #{user.roles.join(', ')}".colorize(:green)
        else
          puts "#{email}: " + "User could not be updated. #{user.errors.join(', ')}".colorize(:red)
        end
      else
        puts "#{email}: " + "User could not be found.".colorize(:red)
      end
    end
  end
end
