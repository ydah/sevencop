# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Identifies passing multi-elements Hash literal to `where.not`.
      #
      # @example
      #
      #   # bad
      #   where.not(key1: value1, key2: value2)
      #
      #   # good
      #   where.not(key1: value1).where.not(key2: value2)
      #
      class RailsWhereNot < Base
        extend AutoCorrector

        MSG = 'Use `where.not(key1: value1).where.not(key2: value2)` style.'

        # @!method rails_where_not_with_multiple_elements_hash?(node)
        def_node_matcher :rails_where_not_with_multiple_elements_hash?, <<~PATTERN
          (send
            (send _ :where) :not
            ({ hash | kwargs }
              (pair _ _)
              (pair _ _)+))
        PATTERN

        def on_send(node)
          return unless rails_where_not_with_multiple_elements_hash?(node)

          add_offense(node) do |corrector|
            pairs = node.children[2].children
            last_end_pos = pairs[0].location.expression.end_pos
            pairs[1..].each do |pair|
              corrector.remove(pair.location.expression.with(begin_pos: last_end_pos))
              last_end_pos = pair.location.expression.end_pos
              corrector.insert_after(node.location.expression, ".where.not(#{pair.source})")
            end
          end
        end
      end
    end
  end
end
