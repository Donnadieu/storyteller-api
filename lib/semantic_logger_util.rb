# frozen_string_literal: true

module SemanticLoggerUtil
  def use_semantic_logger?
    ENV.fetch('SEMANTIC_LOGGER_ENABLED', false).to_s.in?(%w[1 yes true])
  end
end
