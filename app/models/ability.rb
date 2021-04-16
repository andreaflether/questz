# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all # permissions for every user, even if not logged in

    # Additional permissions for logged in users
    if user.present?
      can %i[create upvote downvote], [Question, Answer]
      can %i[feed], Question

      # User can't vote on owned resource
      cannot %i[upvote downvote], [Question, Answer], user_id: user.id

      # User asked the question
      can %i[choose], Answer, question: { status: %w[unanswered answered], user_id: user.id }

      # Can't answer a closed question
      cannot %i[create], Answer, question: { status: 'closed' }

      # User cannot choose their own answer
      cannot %i[choose], Answer, user_id: user.id

      # User owns the resource
      can %i[update destroy], [Question, Answer], user_id: user.id

      # User can't edit/delete a answered question and/or chosen answer
      cannot %i[update], Question, status: 'answered'
      cannot %i[update destroy], Answer, chosen: true, question: { status: 'answered' }

      # Can't delete a Question that has answers
      cannot %i[destroy], Question, &:has_answers?
      cannot %i[update], Question, closing_notice: %w[duplicate]
    end
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
