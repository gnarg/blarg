require File.dirname(__FILE__) + '/../test_helper'

class SofaTest < ActiveSupport::TestCase
  context "when subclassed" do
    setup do
      class SofaFoo < Sofa; end

      @test = SofaFoo.new
      @test.foo = 'bar'
    end
    
    should "be able to receive arbitrary attributes" do
      assert_equal 'bar', @test.foo
    end
    
    should "be castable as a hash" do
      assert_equal({ 'foo' => 'bar' }, @test.to_hash)
    end
    
    context ".all" do
      setup do
        clean_couch
        
        @a = SofaFoo.new('name' => 'A'); @a.save
        @b = SofaFoo.new('name' => 'B'); @b.save
        
        @results = SofaFoo.all
      end
      
      should "return all documents of the given type" do
        assert @results.include?(@a)
        assert @results.include?(@b)
      end
    end
    
    context ".get" do
      setup do
        clean_couch
        resp = COUCHDB.save_doc(:key => 'value')
        @doc = COUCHDB.get(resp['id'])
        @obj = SofaFoo.get(@doc['_id'])
      end
      
      should "retrieve object by id" do
        assert_equal @doc['key'], @obj.key
      end
      
      should "return object cast as the subclass" do
        assert_equal SofaFoo, @obj.class
      end
    end
    
    context "#save" do
      setup do
        clean_couch
        @saved = SofaFoo.new(:foo => 'bar')
        @result = @saved.save
      end
      
      should "assign a couchdb id to the object" do
        assert_equal 32, @saved.id.size
      end
      
      should "set the class name in the couchdb document" do
        assert_equal 'SofaTest::SofaFoo', @saved.document_type
      end
      
      should "persist the object in couchdb" do
        assert_equal COUCHDB.get(@saved.id)['foo'], @saved.foo
      end
      
      should "save updates to an already saved object" do
        @saved.foo = 'baz'
        @saved.stuff = 'junk'
        @saved.save
        in_db = COUCHDB.get(@saved.id)
        assert_equal 'baz', in_db['foo']
        assert_equal 'junk', in_db['stuff']
      end
      
      should "return the id of the saved object" do
        assert_equal @saved.id, @result
      end
    end

    context "#save failure" do
      setup do
        COUCHDB.stubs(:save_doc).returns({'ok' => false })
        @saved = SofaFoo.new(:foo => 'bar')
        @response = @saved.save
      end
      
      should "return nil" do
        assert !@response
      end
      
      should "set an error on the object" do
        assert_equal "Unable to save SofaTest::SofaFoo.", 
          @saved.errors.full_messages.first
      end
    end
    
    context "#merge" do
      setup do
        @obj = SofaFoo.new(:foo => 'bar', :baz => 'cux')
        @obj.merge(:baz => 'test', :new_attr => 'test')
      end
      
      should "set the given attributes on the object" do
        assert_equal 'test', @obj.baz
        assert_equal 'test', @obj.new_attr
      end
    end
    
    context '#replace' do
      setup do
        @obj = SofaFoo.new(:a => 'first', :b => 'second')
        @obj.replace(:b => 'third', :c => 'fourth')
      end
      
      should "have only the new attributes" do
        assert !@obj.to_hash.keys.include?('a')
      end
    end
    
    context '#clone' do
      setup do
        @a = SofaFoo.new(:name => 'A', :foo => 'bar')
        @a.save
        
        @b = @a.clone
      end
      
      should "make a copy" do
        assert_not_equal @a.id, @b.id
        assert_equal @a.foo, @b.foo
      end
    end

    context "timestamps" do
      setup do
        @test.save
      end
      
      should_change "@test.created_at", :from => nil
      should_change "@test.updated_at", :from => nil
      
      should "set updated_at on re-save" do
        @test.updated_at = nil
        assert_nil @test.updated_at
        
        @test.save
        assert_not_nil @test.updated_at
      end
      
      should "be ActiveSupport::TimeWithZone objects" do
        assert_kind_of ActiveSupport::TimeWithZone, @test.created_at
        assert_kind_of ActiveSupport::TimeWithZone, @test.updated_at
      end
    end

    context '#delete' do
      setup do
        @doc = SofaFoo.new
        @doc.save
      end
      
      should "succeed" do
        assert @doc, SofaFoo.get(@doc.id)
        
        @doc.delete
        
        assert_nil SofaFoo.get(@doc.id)
      end
    end
    
    context '#reload' do
      setup do
        @a = SofaFoo.new; @a.save
        @b = SofaFoo.get(@a.id)
        
        @b.name = 'Chris'
        @b.save
      end
      
      should "not have new attribute before reload" do
        assert_nil @a.name
      end
      
      context "after reload" do
        setup do
          @a.reload
        end
        
        should "have new attribute" do
          assert_equal 'Chris', @a.name
        end
      end
    end
  end
end