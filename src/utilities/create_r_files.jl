"""

# `check_dct_type(`

Check if dct == Dict[] and has length > 0. 

### Method
```julia
check_dct_type((dct)
```

### Required arguments
```julia
* `dct::Dict{String, Any}`      : Observed data or parameter init data
```

"""
function check_dct_type(dct)
  if typeof(dct) <: Array && length(dct) > 0
    if typeof(dct) <: Array{Dict{S, T}} where {S <: AbstractString, T <: Any}
      return true
    end
  else
    if typeof(dct) <: Dict{S, T} where {S <: AbstractString, T <: Any}
      return true
    end
  end
  @error "Input $(dct) not of type Dict{String, Any}, but $(typeof(dct))"
  return false
end

"""

# update_R_file 

Rewrite a dictionary of observed data or initial parameter values in R dump file
format to a file. 

### Method
```julia
update_R_file{T<:Any}(file, dct)
```

### Required arguments
```julia
* `file::String`                : R file name
* `dct::Dict{String, T}`        : Dictionary to format in R
```

"""
function update_R_file(file::String, dct::Dict{String, T}) where T <: Any
  isfile(file) && rm(file)
	open(file, "w") do strmout
    str = ""
    for entry in dct
      str = "\""*entry[1]*"\" <- "
      val = entry[2]
      if length(val)==0 && length(size(val))==1          # Empty array
        str = str*"c()\n"
      elseif length(val)==1 && length(size(val))==0          # Scalar
        str = str*"$(val)\n"
          #elseif length(val)==1 && length(size(val))==1    # Single element vector
        #str = str*"$(val[1])\n"
      elseif length(val)>=1 && length(size(val))==1  # Vector
        str = str*"structure(c("
        write(strmout, str)
        str = ""
            writedlm(strmout, val', ',')
        str = str*"), .Dim=c($(length(val))))\n"
      elseif length(val)>1 && length(size(val))>1      # Array
        str = str*"structure(c("
        write(strmout, str)
        str = ""
            writedlm(strmout, val[:]', ',')
        dimstr = "c"*string(size(val))
        str = str*"), .Dim=$(dimstr))\n"
      end
      write(strmout, str)
    end
  end
end

