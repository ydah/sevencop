# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Pass HTTP endpoint identifier to top-level `describe` on request-specs.
      #
      # @see https://github.com/r7kamura/rspec-request_describer
      #
      # @example
      #   # bad
      #   RSpec.describe 'Users'
      #
      #   # good
      #   RSpec.describe 'GET /users'
      class RSpecDescribeHttpEndpoint < Base
        MSG = 'Pass HTTP endpoint identifier to top-level `describe` on request-specs.'

        RESTRICT_ON_SEND = %i[
          describe
        ].freeze

        SUPPORTED_HTTP_METHODS = %w[
          DELETE
          GET
          PATCH
          POST
          PUT
        ].freeze

        DESCRIPTION_PATTERN = %r{\A#{::Regexp.union(SUPPORTED_HTTP_METHODS)} /}.freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          return unless bad?(node)

          add_offense(node.first_argument)
        end

        private

        # @!method describing_http_endpoint_identifier?(node)
        #   @param node [RuboCop::AST::SendNode]
        #   @return [Boolean]
        def_node_matcher :describing_http_endpoint_identifier?, <<~PATTERN
          (send
            _
            :describe
            (str DESCRIPTION_PATTERN)
            ...
          )
        PATTERN

        # @!method describing_at_top_level?(node)
        #   @param node [RuboCop::AST::SendNode]
        #   @return [Boolean]
        def_node_matcher :describing_at_top_level?, <<~PATTERN
          (send
            (const
              {nil? cbase}
              :RSpec
            )
            :describe
            ...
          )
        PATTERN

        # @param node [RuboCop::AST::SendNode]
        def bad?(node)
          describing_at_top_level?(node) &&
            !describing_http_endpoint_identifier?(node)
        end
      end
    end
  end
end
