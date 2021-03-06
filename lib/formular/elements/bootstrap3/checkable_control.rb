require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/modules/wrapped_control'
require 'formular/elements/module'

module Formular
  module Elements
    module Bootstrap3
      module CheckableControl
        module InlineCheckable
          include Formular::Elements::Module

          html(:wrapped) do |input|
            input.wrapper do
              concat input.group_label
              concat input.hidden_tag unless input.collection?
              if input.has_group_label?
                concat Formular::Elements::Div.(content: input.to_html(context: :collection))
              else
                concat input.to_html(context: :collection)
              end
              concat input.hidden_tag if input.collection?
              concat input.hint
              concat input.error
            end
          end
        end # class InlineCheckable

        class InlineRadio < Formular::Elements::Radio
          include Formular::Elements::Modules::WrappedControl
          include InlineCheckable

          add_option_keys :control_label_options
          set_default :control_label_options, { class: ['radio-inline'] }

          def hidden_tag
            ''
          end
        end# class InlineRadio

        class InlineCheckbox < Formular::Elements::Checkbox
          include Formular::Elements::Modules::WrappedControl
          include InlineCheckable

          set_default :control_label_options, { class: ['checkbox-inline'] }
          set_default :value, '1' # instead of reader value

          html { closed_start_tag }
        end # class InlineCheckbox

        module StackedCheckable
          include Formular::Elements::Module

          html(:wrapped) do |input|
            input.wrapper do
              concat input.group_label
              concat input.hidden_tag unless input.collection?
              concat input.to_html(context: :collection)
              concat input.hidden_tag if input.collection?
              concat input.hint
              concat input.error
            end
          end

          html(:collection) do |input|
            input.collection.map { |control|
              control.inner_wrapper { control.to_html(context: :checkable_label) }
            }.join('')
          end

          module InstanceMethods
            def inner_wrapper(&block)
              Formular::Elements::Div.(class: inner_wrapper_class, &block).to_s
            end
          end
        end # module StackedCheckable

        class Checkbox < Formular::Elements::Checkbox
          include Formular::Elements::Modules::WrappedControl
          include StackedCheckable

          set_default :value, '1' # instead of reader value

          html { closed_start_tag }

          def inner_wrapper_class
            ['checkbox']
          end
        end # class Checkbox

        class Radio < Formular::Elements::Radio
          include Formular::Elements::Modules::WrappedControl
          include StackedCheckable

          def inner_wrapper_class
            ['radio']
          end

          def hidden_tag
            ''
          end
        end # class Radio
      end # module CheckableControl
    end # module Bootstrap3
  end # module Elements
end # module Formular
