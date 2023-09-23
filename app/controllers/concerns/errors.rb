# frozen_string_literal: true

module Errors
  class Unauthorized < StandardError
  end

  class UnprocessableEntity < StandardError
  end

  class IDTokenVerificationFailed < StandardError
  end

  class AccessTokenRequestFailed < StandardError
  end
end
