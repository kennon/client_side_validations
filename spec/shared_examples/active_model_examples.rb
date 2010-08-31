shared_examples_for 'ActiveModel' do
  it_should_behave_like "Validate Options"
  describe 'to hash' do
    it "should support validate_presence_of" do
      Klass.class_eval { validates_presence_of :string }
      instance      = Klass.new
      expected_hash = { "presence" => { "message" => "can't be blank"} }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it "should support validates_format_of of" do
      Klass.class_eval { validates_format_of :string, :with => /\A\d\Z/i }
      instance      = Klass.new
      expected_hash = { "format" => { "message" => "is invalid", "with" => "^\\d$" } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it "should support different ways to write regex" do
      Klass.class_eval do
        validates_format_of :string, :with => /^\d$/i
        validates_format_of :string_2, :with => /\d/
      end
      instance        = Klass.new
      expected_hash_1 = { "format" => { "message" => "is invalid", "with" => "^\\d$" } }
      expected_hash_2 = { "format" => { "message" => "is invalid", "with" => "\\d" } }
      result_hash_1   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash_2   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string_2)
      result_hash_1.should == expected_hash_1
      result_hash_2.should == expected_hash_2
    end

    it "should support is validates_length_of" do
      Klass.class_eval { validates_length_of :string, :is => 10 }
      instance      = Klass.new
      expected_hash = { "length" => { "message" => "is the wrong length (should be 10 characters)", "is" => 10 } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it "should support minimum validates_length_of" do
      Klass.class_eval { validates_length_of :string, :minimum => 10 }
      instance      = Klass.new
      expected_hash = { "length" => { "message" => "is too short (minimum is 10 characters)", "minimum" => 10 } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it "should support maximum validates_length_of of" do
      Klass.class_eval { validates_length_of :string, :maximum => 10 }
      instance      = Klass.new
      expected_hash = { "length" => { "message" => "is too long (maximum is 10 characters)", "maximum" => 10 } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it "should support range validates_length_of of" do
      Klass.class_eval { validates_length_of :string, :within => 5..10 }
      instance      = Klass.new
      expected_hash = { "length" => { "message_min" => "is too short (minimum is 5 characters)", "minimum" => 5,
                                      "message_max" => "is too long (maximum is 10 characters)", "maximum" => 10 } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end
  
    it "should alias validates_size_of to validates_length_of" do
      Klass.class_eval { validates_size_of :string, :minimum => 10 }
      instance      = Klass.new
      expected_hash = { "length" => { "message" => "is too short (minimum is 10 characters)", "minimum" => 10 } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it "should support validating the validates_numericality_of" do
      Klass.class_eval { validates_numericality_of :integer }
      instance      = Klass.new
      expected_hash = { "numericality" => { "message" => "is not a number" } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:integer)
      result_hash.should == expected_hash
    end
  
    it 'should support validates_confirmation_of' do
      Klass.class_eval { validates_confirmation_of :string }
      instance      = Klass.new
      expected_hash = { "confirmation" => { "message" => "doesn't match confirmation" } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end
  
    it 'should support validates_inclusion_of' do
      Klass.class_eval { validates_inclusion_of :string, :in => ['hey'] }
      instance      = Klass.new
      expected_hash = { "inclusion" => { "message" => "is not included in the list", "in" => ['hey'] } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it 'should support validates_inclusion_of with a range' do
      Klass.class_eval { validates_inclusion_of :number, :in => (1..2) }
      instance      = Klass.new
      expected_hash = { "inclusion" => { "message" => "is not included in the list", "in" => [1,2] } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:number)
      result_hash.should == expected_hash
    end

    it 'should support validates_exclusion_of' do
      Klass.class_eval { validates_exclusion_of :string, :in => ['hey'] }
      instance      = Klass.new
      expected_hash = { "exclusion" => { "message" => "is reserved", "in" => ['hey'] } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it 'should support validates_exclusion_of with a range' do
      Klass.class_eval { validates_exclusion_of :number, :in => (1..2) }
      instance      = Klass.new
      expected_hash = { "exclusion" => { "message" => "is reserved", "in" => [1,2] } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:number)
      result_hash.should == expected_hash
    end
  
    it 'should support validates_acceptance_of' do
      Klass.class_eval { validates_acceptance_of :string }
      instance      = Klass.new
      expected_hash = { "acceptance" => { "message" => "must be accepted" } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it "should strip out the AR callback options" do
      Klass.class_eval do
        validates_presence_of :string, :on => :create
        def new_record?
          true
        end
      end
      
      instance      = Klass.new
      expected_hash = { "presence" => { "message" => "can't be blank"} }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash.should == expected_hash
    end

    it "should support multiple validations for the same method" do
      Klass.class_eval do
        validates_presence_of :integer
        validates_numericality_of :integer
      end
  
      instance      = Klass.new
      expected_hash = { "presence" => { "message" => "can't be blank" },
                        "numericality" => { "message" => "is not a number" } }
      result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:integer)
      result_hash.should == expected_hash
    end

    context 'with custom validation messages' do
      before do
        add_translation(:en, :klass => { :attributes => { :string_2 => { :presence => "String_2" } } })
    
        Klass.class_eval do
          validates_presence_of :string, :message => "String"
          validates_presence_of :string_2, :message => :presence
        end
      end
  
      after do
        remove_translation(:en, :klass)
      end
  
      it 'should have a message of "String" for #string' do
        instance      = Klass.new
        expected_hash = { "presence" => { "message" => "String" } }
        result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
        result_hash.should == expected_hash
      end

      it 'should have a message of "String_2" for #string_2' do
        instance      = Klass.new
        expected_hash = { "presence" => { "message" => "String_2" } }
        result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string_2)
        result_hash.should == expected_hash
      end
    end

    context 'Other languages' do
      before do
        add_translation(:es, :klass => { :attributes => { :string => { :presence => "String-es" } } })
    
        Klass.class_eval do
          validates_presence_of :string, :message => :presence
        end
        I18n.locale = 'es'
      end
  
      after do
        remove_translation(:es, :klass)
        I18n.locale = 'en'
      end
  
      it 'should result in "String-es" for Spanish translations' do
        instance      = Klass.new
        expected_hash = { "presence" => { "message" => "String-es" } }
        result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
        result_hash.should == expected_hash
      end
  
      it 'should result in "String-es" for Spanish translations when passed string "es" instead of symbol' do
        instance      = Klass.new
        expected_hash = { "presence" => { "message" => "String-es" } }
        result_hash   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
        result_hash.should == expected_hash
      end
    end

    it "should support the regular validate method" do
      Klass.class_eval do
        validate :do_something
    
        def do_something
          errors.add(:string, "test this out")
        end
      end
  
      instance = Klass.new
      # TODO: Unsupported right now
    end

    def add_translation(lang, hash)
      if defined?(::ActiveModel)
        validations = {
          :errors => {
            :models => hash
          }
        }
      else
        validations = {
          :activerecord => {
            :errors => {
              :models => hash
            }
          }
        }
      end
      I18n.backend.store_translations(lang, validations)
    end

    def remove_translation(lang, key)
      if defined?(::ActiveModel)
        model_validations = I18n.translate('errors.models')
      else
        model_validations = I18n.translate('activerecord.errors.models')
      end
      model_validations.delete(key)
      if defined?(::ActiveModel)
        validations = {
          :errors => model_validations
        }
      else
        validations = {
          :activerecord => {
            :errors => model_validations
          }
        }
      end
      I18n.backend.store_translations(lang, validations)
    end
  end

  describe 'fields' do
    it 'should only return field names that have validations' do
      Klass.class_eval do
        validates_presence_of     :number_1
        validates_numericality_of :number_2
      end
  
      instance        = Klass.new
      expected_fields = [:number_1, :number_2]
      result_fields   = instance.send(:validation_fields).map { |k| k.to_s }.sort.map { |k| k.to_sym }
      result_fields.should == expected_fields
    end
  
    it 'should only return a single field name if assigned multiple validations' do
      Klass.class_eval do
        validates_presence_of     :number_1
        validates_numericality_of :number_1
      end
    
      instance        = Klass.new
      expected_fields = [:number_1]
      result_fields   = instance.send(:validation_fields)
      result_fields.should == expected_fields
    end
  end

  describe 'conditional' do
    before do
      define_abstract_ar(:Klass2, ActiveRecord::Base)
    end
  
    after do
      Object.send(:remove_const, :Klass2)
    end
    
    it 'should support validations with conditionals' do
      Klass.class_eval do
        validates_presence_of :string, :if => :need_string?
        validates_presence_of :string_2, :unless => :need_string?
        validates_presence_of :integer, :if => :need_integer?
    
        validates_presence_of :string_3, :allow_validation => :need_string?
        validates_presence_of :string_4, :skip_validation => :need_string?
        validates_presence_of :integer_2, :allow_validation => :need_integer?
    
        def need_string?
          true
        end
    
        def need_integer?
          false
        end
      end
  
      instance        = Klass.new

      expected_hash_1 = { 'presence' => { 'message' => "can't be blank" } }
      result_hash_1   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string)
      result_hash_1.should == expected_hash_1
  
      expected_hash_2 = { }
      result_hash_2   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string_2)
      result_hash_2.should == expected_hash_2
  
      expected_hash_3 = { }
      result_hash_3   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:integer)
      result_hash_3.should == expected_hash_3

      expected_hash_4 = { 'presence' => { 'message' => "can't be blank" } }
      result_hash_4   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string_3)
      result_hash_4.should == expected_hash_4
  
      expected_hash_5 = { }
      result_hash_5   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:string_4)
      result_hash_5.should == expected_hash_5
  
      expected_hash_6 = { }
      result_hash_6   = ClientSideValidations::ORM::ValidateOptions.new(instance).validations_for(:integer_2)
      result_hash_6.should == expected_hash_6
    end

    context ':on =>' do
      before do
        Klass.class_eval do
          validates_presence_of :string_1, :on => :create
          validates_presence_of :string_2, :on => :update
          def new_record?
            true
          end
        end
      
        Klass2.class_eval do
          validates_presence_of :string_1, :on => :create
          validates_presence_of :string_2, :on => :update
          def new_record?
            false
          end
        end
      end
    
      it ':create' do
        instance_1 = Klass.new
        instance_2 = Klass2.new
      
        ClientSideValidations::ORM::ValidateOptions.new(instance_1).validations_for(:string_1).should_not be_empty
        ClientSideValidations::ORM::ValidateOptions.new(instance_1).validations_for(:string_1).should_not be_empty

        ClientSideValidations::ORM::ValidateOptions.new(instance_2).validations_for(:string_1).should be_empty
      end
    
      it ':update' do
        instance_1 = Klass.new
        instance_2 = Klass2.new
      
        ClientSideValidations::ORM::ValidateOptions.new(instance_1).validations_for(:string_2).should be_empty
        ClientSideValidations::ORM::ValidateOptions.new(instance_2).validations_for(:string_2).should_not be_empty
      end
    end
  end
  
  describe 'Unsupported validations' do
    before do
      @attr      = :string
      kind       = :unsupported
      options    = { }
      validation = mock("Validation")
      validation.stubs(:options).returns(options)
      validation.stubs(:kind).returns(kind)
      Klass.any_instance.stubs(:_validators).returns({ @attr => [validation] })
    end

    it 'should not add unsupported validations' do
      ClientSideValidations::ORM::ValidateOptions.new(Klass.new).validations_for(:string).should == { }
    end
  end
end