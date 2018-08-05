# This file stores variables which are used by the build script

# Storing all values in a single $Settings variable to make it obvious that the values are coming from this BuildSettings file when accessing them.
$Settings = @{

    CoverallsKey = $env:Coveralls_Key
}
