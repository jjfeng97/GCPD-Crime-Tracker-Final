class Ability
  include CanCan::Ability

  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :commish
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :chief
      # can manage investigations, investigation notes, crime investigations,
        # criminals, suspects, and assignments
      can :manage, Investigation
      can :manage, InvestigationNote
      can :manage, CrimeInvestigation
      can :manage, Criminal
      can :manage, Suspect
      can :manage, Assignment
      
      # can read all
      can :read, :all

      # can update own unit
      can :update, Unit do |u|  
        u.id == user.officer.unit.id
      end

      # can manage officers in their unit
      can :manage, Officer do |o|
        o.unit.id == user.officer.unit.id
      end

      # can manage their own user profile
      can :manage, User do |u|  
        u.id == user.id
      end


    elsif user.role? :officer
      # can read, new, and create investigations
      can :read, Investigation
      can :new, Investigation
      can :create, Investigation

      # can only update investigation if they are currently assigned to it
      can :update, Investigation do |i|
        assignments_list = user.officer.assignments.current.map(&:investigation_id)
        assignments_list.include? i.id
      end

      # can manage investigation notes, crime investigations, criminals, and suspects
        # can read assignments and crimes
      can :manage, InvestigationNote
      can :read, Assignment
      can :read, Crime
      can :manage, CrimeInvestigation
      can :manage, Criminal
      can :manage, Suspect

      # can read their own officer data
      can :read, Officer do |o|  
        o.id == user.officer.id
      end

      # can update their own officer data
      can :update, Officer do |o|  
        o.id == user.officer.id
      end

      # can read their own user data
      can :read, User do |u|  
        u.id == user.id
      end

      # can update their own user data
      can :update, User do |u|  
        u.id == user.id
      end

      # can see list of units
      can :index, Unit

      # can read their own unit's data
      can :show, Unit do |u|  
        u.id == user.officer.unit.id
      end
      
    else
      # guests can only read crimes (plus home pages)
      can :read, Crime
    end
  end
end
