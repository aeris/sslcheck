module CryptCheck
  module Tls
    class Host < CryptCheck::Host
      private

      def server(*args)
        Server.new *args
      end
    end
  end
end
