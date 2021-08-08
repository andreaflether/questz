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
      cannot %i[create], Answer, question: { status: 'closed', user_id: user.id }

      # User asked the question
      can %i[choose], Answer, question: { status: %w[unanswered], user_id: user.id }

      # User cannot choose their own answer
      cannot %i[choose], Answer, user_id: user.id

      # User owns the resource
      can %i[update destroy], [Question, Answer], user_id: user.id

      # User can't edit/delete a answered question and/or chosen answer
      cannot %i[update], Question, status: 'answered'
      cannot %i[update destroy], Answer, chosen: true, question: { status: 'answered' }

      # Can't delete a Question that has answers
      cannot %i[destroy], Question, &:has_answers?

      # Can't update a Question closed for being duplicated
      cannot %i[update], Question, closing_notice: %w[duplicate]

      # Can't report own Question/Answer
      cannot %i[create], Report, reportable: { user_id: user.id }

      if user.adm? || user.mod?
        can :manage, :all

        # Admins or Moderators can't choose an Answer
        cannot %i[choose], Answer

        # Can only assign if is pending
        cannot %i[assign], Report, status: %w[ongoing closed solved]

        # Can't mark Report as solved if is already closed
        cannot %i[solve], Report, status: %w[closed solved]

        # Can't close Report if it is already solved or solved
        cannot %i[close], Report, status: %w[closed solved]

        # Can't solve or close if it's pending
        cannot %i[close solve], Report, status: %w[pending]
      end
    end
  end
end
