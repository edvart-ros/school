classdef Triangle < handle
    %EXAMPLEHANDLECLASS Class used for .NET Engine examples.
    
    properties
        Base
        Height
    end
    properties (Dependent)
        Area
    end
    
    methods
        function obj = Triangle(base, height)
            %EXAMPLEHANDLECLASS Construct an instance of this class.
            obj.Base = base;
            obj.Height = height;
        end
        
        function resize(obj, scale)
            %RESIZE Multiplies the Base and Height by SCALE.
            obj.Base = obj.Base * scale;
            obj.Height = obj.Height * scale;
        end

        function area = get.Area(obj)
            area = obj.Base * obj.Height / 2;
        end
    end
end

