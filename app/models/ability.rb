# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can %i[create upvote downvote], [Question, Answer]
      can %i[feed], Question

      # User can't vote on owned resource
      cannot %i[upvote downvote], [Question, Answer], user_id: user.id

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

      # User asked the question
      can %i[choose], Answer, question: { status: %w[unanswered], user_id: user.id }

      # Can't update a Question closed for being duplicated
      cannot %i[update], Question, closing_notice: %w[duplicate]
      
      if user.adm? || user.mod?
        can :manage, :all
        cannot %i[choose], Answer
      end
    end
  end
end
