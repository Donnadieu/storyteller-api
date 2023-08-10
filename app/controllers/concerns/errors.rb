module Errors
  class Unauthorized < StandardError
  end

  class IDTokenVerificationFailed < StandardError
  end

  class AccessTokenRequestFailed < StandardError
  end
end
