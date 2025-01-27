# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Sort Hash elements by key.
      #
      # @example
      #
      #   # bad
      #   {
      #     b: 1,
      #     a: 1,
      #     c: 1
      #   }
      #
      #   # good
      #   {
      #     a: 1,
      #     b: 1,
      #     c: 1
      #   }
      #
      class HashElementOrdered < Base
        extend AutoCorrector

        MSG = 'Sort Hash elements by key.'

        # @!method hash_literal?(node)
        def_node_matcher :hash_literal?, <<~PATTERN
          (hash
            (pair
              {sym | str}
              _
            )+
          )
        PATTERN

        # @param [RuboCop::AST::HashNode] node
        def on_hash(node)
          return unless hash_literal?(node)

          return if sorted?(node)

          add_offense(node) do |corrector|
            corrector.replace(
              node,
              autocorrect(node)
            )
          end
        end

        private

        # @param [RuboCop::AST::HashNode] node
        # @return [String]
        def autocorrect(node)
          parts = [
            whitespace_leading(node),
            sort(node.pairs).map(&:source).join(",#{whitespace_between(node)}"),
            whitespace_trailing(node)
          ]
          parts = ['{', *parts, '}'] if node.braces?
          parts.join
        end

        # @param [RuboCop::AST::HashNode] node
        # @return [Integer]
        def offset_for(node)
          if node.braces?
            1
          else
            0
          end
        end

        # @param [Array<RuboCop::AST::PairNode>] pairs
        # @return [Array<RuboCop::AST::PairNode>]
        def sort(pairs)
          pairs.sort_by do |pair|
            pair.key.value
          end
        end

        # @param [RuboCop::AST::HashNode] node
        # @return [Boolean]
        def sorted?(node)
          node.pairs.map(&:source) == sort(node.pairs).map(&:source)
        end

        # @param [RuboCop::AST::HashNode] node
        # @return [String]
        #   {    a: 1,   b: 1  }
        #             ^^^
        def whitespace_between(node)
          if node.pairs.length >= 2
            processed_source.raw_source[
              node.pairs[0].location.expression.end_pos + 1...node.pairs[1].location.expression.begin_pos
            ]
          else
            ' '
          end
        end

        # @param [RuboCop::AST::HashNode] node
        # @return [String]
        #   {    a: 1,   b: 1  }
        #    ^^^^
        def whitespace_leading(node)
          processed_source.raw_source[
            node.location.expression.begin.end_pos + offset_for(node)...node.pairs[0].location.expression.begin_pos
          ]
        end

        # @param [RuboCop::AST::HashNode] node
        # @return [String]
        #   {    a: 1,   b: 1  }
        #                    ^^
        def whitespace_trailing(node)
          processed_source.raw_source[
            node.pairs[-1].location.expression.end_pos...node.location.expression.end.begin_pos - offset_for(node)
          ]
        end
      end
    end
  end
end
