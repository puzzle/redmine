module HTTPAuthPatch
  unloadable
  
  def self.included(base)
    base.send(:include, ClassMethods)
    base.class_eval do
      #avoid infinite recursion in development mode on subsequent requests
      alias_method :find_current_user,
        :find_current_user_without_httpauth if method_defined? 'find_current_user_without_httpauth'
      #chain our version of find_current_user implementation into redmine core
      alias_method_chain(:find_current_user, :httpauth)
    end
  end

  module ClassMethods

    def find_current_user_with_httpauth
      if request.env['REMOTE_USER']
         user = try_login(request.env['REMOTE_USER'])
         return user if user
      end      
      #first proceed with redmine's version of finding current user
      find_current_user_without_httpauth
    end

    def try_login(remote_username)
      #find user by login name or email address
      user = User.active.find_by_login remote_username
      if (user && user.is_a?(User))
        session[:user_id] = user.id
        session[:http_authentication] = true
        user.update_attribute(:last_login_on, Time.now) if user && !user.new_record?
        User.current = user
      else
        return nil
      end
    end

  end
end

