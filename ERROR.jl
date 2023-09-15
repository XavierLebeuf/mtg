mutable struct Human{F<:Function}
    name::String
    actions::Vector{F}
end

Human_name_only(name::String,
                actions = Function[]) where F =
                Human(name,
                      actions)

Human_func_only(; actions::Vector{Function},
                name = "no_name") where F =
                Human(name,
                      actions)

f(x) = x

a = Human_name_only("paul")
b = Human("paul", [f])
c = Human_func_only(actions=[f])