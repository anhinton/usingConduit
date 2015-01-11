% Guide to using conduit
% Ashley Noel Hinton





Quick start: running a pipeline
-------------------------------

### Installing conduit

conduit is an R package built using R version 3.1.x on a 64-bit Linux
machine. It requires the following R packages: 'XML', 'graph', 'RBGL',
'RCurl', and 'tools'. The 'devtools' package is required to install
conduit directly from github. The 'Rgraphviz' and 'gridGraphviz'
packages are required to run the modules in this example.

Version 0.1 of the packages, built 2015-02-08, is [available for
download](conduit_0.1-0.tar.gz).

Source code for conduit is available at
<https://github.com/anhinton/conduit> for those who would like to
build and install the package manually.

To install conduit using 'devtools':


```r
install.packages("devtools")
devtools::install_github("anhinton/conduit")
```

Load the conduit package:


```r
library(conduit)
```

### Reading a pipeline from an XML file

The `loadPipeline()` function is used to read a pipeline XML file into
conduit.  `loadPipeline()` requires a `name` argument, and a `ref`
argument which describes the XML file location The function returns a
`pipeline` object.

We will load our the pipeline used in out pipelines example above. The
pipeline XML file is in a sub-directory of the R working directory
called 'simpleGraph'.


```r
## load the simpleGraph pipeline
simpleGraph <- 
    loadPipeline(name = "simpleGraph", ref="simpleGraph/pipeline.xml")
```

According to its `description`:



    This pipeline creates a directed graphNEL graph, lays it out using the Rgraphviz package, and then plots the graph as a PNG file using the gridGraphviz package

### Run a pipeline in conduit

The `runPipeline()` function is used to run a `pipeline` object in
R. It requires a `pipeline` object as its only argument. This function
will create a directory for the pipeline in the 'pipelines'
sub-directory of the current working directory. If a 'pipelines'
sub-directory does not exist it will be created. Each module in the
pipeline will create output in a named directory found in
./pipelines/PIPELINE_NAME/modules.


```r
## run the simpleGraph pipeline
runPipeline(simpleGraph)
```

This creates the following files:

 1. [pipelines/simpleGraph/modules/createGraph/directedGraph.rds](pipelines/simpleGraph/modules/createGraph/directedGraph.rds)
 2. [pipelines/simpleGraph/modules/createGraph/script.R](pipelines/simpleGraph/modules/createGraph/script.R)
 3. [pipelines/simpleGraph/modules/layoutGraph/Ragraph.rds](pipelines/simpleGraph/modules/layoutGraph/Ragraph.rds)
 4. [pipelines/simpleGraph/modules/layoutGraph/script.R](pipelines/simpleGraph/modules/layoutGraph/script.R)
 5. [pipelines/simpleGraph/modules/plotGraph/example.png](pipelines/simpleGraph/modules/plotGraph/example.png)
 6. [pipelines/simpleGraph/modules/plotGraph/script.R](pipelines/simpleGraph/modules/plotGraph/script.R)

File number 5, [pipelines/simpleGraph/modules/plotGraph/example.png](pipelines/simpleGraph/modules/plotGraph/example.png)
is the output file we require, the PNG image of the graph. The image is shown
below:

![Pipeline output: PNG image file of graph](pipelines/simpleGraph/modules/plotGraph/example.png)


Searching for files in conduit
------------------------------

conduit allows the user to either specify the location of a resource
file, or to provide a filename and file location(s) where the file
should be found.  Functions which have `ref` and `path` arguments
provide the option to search for a resource.

If the value of `ref` is an absolute resource address, e.g. a full
file path, then no further searching will be done. Relative file paths
can also be provided to `ref` arguments.



If no resource can be sensibly found at `ref`, a search is
started. Conduit will search by default in the directory for the
module or pipeline which initiated the search, then R's current
working directory. The default search paths can be amended or replaced
by the `path` argument. Search paths are given as character strings, with
each path divided by the '|' character. Values for `path`
which end in '|' will be prepended to the default search paths, and
those which beging with '|' will be appended.

conduit will search in each search path provided until a matching file
is located. The first match will be returned.

The following example will attemp to load a module by searching for a file named in `ref` in the paths listed in `path`, and then the default search paths.


```r
mod1 <- loadModule(name = "loader", ref = "arrangeLines.xml",
                   path = "~/openapi|/media/ashley/floppyDisk|")
```


modules
-------

This sections describes how to: load modules from XML files; create
modules; execute module source scripts; save modules as module XML
files.

### Loading modules from XML

#### `loadModule()`

This function reads and interprets a module XML file, producing a
`module` object in R. It requires the following arguments:

  + `name`: module name (must be unique within a pipeline)
  + `ref`: Filename or file path of xml file.
      - `path`: optional search path(s) for `ref` resource

`loadModule()` also accepts a `namespaces` argument, which should be a named
character vector of namespaces used in the module XML file. The default
value for `namespaces` is `c(oa = "http://www.openapi.org/2014/"))`.

Example:


```r
plotGraphXML <- file.path("simpleGraph", "plotGraph.xml")
plotGraph <- loadModule(name = "plotGraph",
                        ref = plotGraphXML)
```

### Creating modules

Modules can be created in conduit using the `module()` function and
its associated helper functions. The resulting modules can be executed
in conduit, or saved to disk as module XML files.

The following example shows how a module can be created.


```r
## create input, output, and source lists
inputsList <- 
    list(moduleInput("myGraph", "internal", "R \"graphNEL\" object"))
outputsList <-
    list(moduleOutput("Ragraph", "internal", "R \"Ragraph\" object"))
sourcesList <-
    list(moduleSource(value = c("library(Rgraphviz)", 
                                "Ragraph <- agopen(myGraph, \"myGraph\")")))
## create module
layoutGraph <- module(name = "layoutGraph", platform = "R",
                      description = "Lays out a graphNEL graph using the Rgraphviz package",
                      inputs = inputsList,
                      outputs = outputsList,
                      sources = sourcesList)
```

#### `module()`

The `module()` function is used to create module objects.

Required aruments:

  + `name`: module name (must be unique within a pipeline)
  + `platform`: name of platform required to execute module source

Optional arguments:
  
  + `description`: a brief description of what the module does
  + `inputs`: a list of [`moduleInput`](#moduleinput) objects
  + `outputs`: a list of [`moduleOutput`](#moduleoutput) objects
  + `sources`: a list of [`moduleSource`](#modulesource) objects
  + `path`: search path to be used by module's source(s)

Examples:

```r
mod1 <- module(name = "cleanCSV", platform = "R",
               description = "clean up the data in a CSV file",
               inputs = inputsList1, outputs = outputsList1,
               sources = sourcesList1)
```

#### `moduleInput()`

The `moduleInput()` function is used to create the inputs for modules
created in R with the `module()` function. Each input should
correspond to an object of the same name in the module's source(s). It
requires the following arguments:

  + `name`: input name (must be unique within a module)
  + `type`: "internal" or "external"

Optional arguments:

  + `format`: format of input for validation, e.g. "R data frame"
  + `formatType`: type of object given to be used for validation. Defaults
    to "text" to perform text-matching of `format`s.

Examples:

```r
inp1 <- moduleInput(name = "pollingBooths", type = "internal",
                    format = "R data frame")
inp2 <- moduleInput(name = "boothLatLong", type = "external", 
                    format = "CSV file", formatType = "text")
```

#### `moduleOutput()`

The `moduleOutput()` function is used to create the outputs for
modules created in R with the `module()` function. Each "internal"
output should correspond to an object of the same name in the module's
source(s). "external" outputs are not produced by conduit, but are
produced directly by the module source script(s). It is recommended
that an "external" output have the same `name` and `ref`, though this
is not compulsory. `moduleOutput()` requires the following arguments:

  + `name`: output name (must be unique within a module)
  + `type`: "internal" or "external"
      - `ref`: if the output `type` is "external" a `ref` must be provided.
        This provides the file location of the external output produced by the
	module source(s). This should be either a filename if the source(s)
	produce the file in the working direcory, or the full resource
	location of the external file. Relative file paths should not be
	used.

Optional arguments:

  + `format`: format of input for validation, e.g. "R data frame"
  + `formatType`: type of object given to be used for validation. Defaults
    to "text" to perform text-matching of `format`s.

Examples:

```r
outp1 <- moduleOutput(name = "pollingBooths", type = "internal",
                      format = "R data frame")
outp2 <- moduleOutput(name = "boothCoords.csv", type = "external", 
                      format = "CSV file", ref = "boothCoords.csv")
```

#### `moduleSource()`

The `moduleSource()` function creates source objects. These objects 
contain the scripts which are to be executed using a module's platform.

A source script can either be provided inline as a character vector, or
as a reference to a script file.

Arguments:

  + `value`: a character vector containing the script to be executed. If `value`
    argument is empty, and a `ref` is provided, script will be read from the
    resource provided in `ref`.
  + `ref`: Filename or file location of a text script file.
      - `path`: optional search path(s) for `ref` resource
  + `type`: not used as at 2015-01-07.
  + `order`: numeric value specifying the position of execution of this source
    in the module's sources. Module sources are executed in the following
    order:
      1. negative numbers in ascending order
      2. 0 (zero)
      3. no order specified
      4. positive numbers in ascending order

Examples:

```r
script1 <- "pollingPlaces <- read.csv(file = csv_input)"
source1 <- moduleSource(value = script1)
source2 <- moduleSource(ref = "plotting.R", path = "~/handyScripts", 
                        order = "-1")
```

### Executing module scripts

#### `runModule()`

Module source scripts are executed using the `runModule()`
function. The function makes the module's inputs available to the
source script(s) in the designated platform, and executes the source
script(s). The module's outputs are saved to a directory called
`modules`, in a subdirectory with the module's name. This function requires
the following arguments:

  + `module`: a module object, usually from `module()` or `loadModule()`
  + `inputs`: a named list of absolute locations of module's inputs
  + `targetDirectory`: file path for `modules` output directory

Examples:


```r
## run a module with no inputs
createGraphXML <- file.path("simpleGraph", "createGraph.xml")
createGraph <- loadModule(name = "createGraph", ref = createGraphXML)
runModule(module = createGraph, targetDirectory = getwd())
```

The module's output can be found in 
[modules/createGraph](modules/createGraph):  

  + [directedGraph.rds](modules/createGraph/directedGraph.rds)



```r
## run a module with an input
layoutGraphXML <- file.path("simpleGraph", "layoutGraph.xml")
layoutGraph <- loadModule("layoutGraph", layoutGraphXML)
## this module uses the output from the previous module as input
myGraph <- file.path("modules", "createGraph", "directedGraph.rds")
runModule(module = layoutGraph,
          inputs = c(myGraph = normalizePath(myGraph)))
```

### Saving modules as XML files

#### `saveModule()`

This function saves a module to disk as a module XML file. This
function requires a `module` object be passed to the `module`
argument. The function also accepts the following optional arguments:

  + `targetDirectory`: location to save XML file. This defaults to the
    current working directory.
  + `filename`: name of resulting XML file. If not specified the file will
    be given the `module` name with '.xml' appended.

The full path of the resulting file is returned.

Examples:

Specify the filename for the new module XML file:


```r
createGraph <- loadModule("createGraph", 
                          file.path("simpleGraph", "createGraph.xml"))
tempTarget <- tempdir()
saveModule(module = createGraph, targetDirectory = tempTarget,
           filename = "newCreateGraph.xml")
```

```
## [1] "/tmp/RtmpFVYWeb/newCreateGraph.xml"
```

Save a module to XML without specifiying the filename:


```r
layoutGraph <- loadModule("layoutGraph", 
                          file.path("simpleGraph", "layoutGraph.xml"))
layoutGraph$name
```

```
## [1] "layoutGraph"
```

```r
saveModule(module = layoutGraph, targetDirectory = tempTarget)
```

```
## [1] "/tmp/RtmpFVYWeb/layoutGraph.xml"
```


pipelines
---------

This sections describes how to: load pipelines from XML files; create
pipelines ; execute pipeline components; save pipelines and their
components as XML files.

### Loading pipelines from XML

#### `loadPipeline()`

This function reads and interprets a pipeline XML file, producing a
`pipeline` object in R. The function will also read and interpret
module and pipeline XML provided in the XML's file `<component>`
nodes. The resulting objects will be loaded into the `components` slot
of the parent `pipeline` object. `loadPipeline()` requires the
following arguments:

  + `name`: pipeline name
  + `ref`: Filename or file path of XML file.
     - `path`: optional search path(s) for `ref` resource

`loadPipeline()` also accepts a `namespaces` argument, which should be a named
character vector of namespaces used in the pipeline XML file. The default
value for `namespaces` is `c(oa = "http://www.openapi.org/2014/"))`.

Example:


```r
simpleGraph <- loadPipeline(name = "simpleGraph",
                            ref = file.path("simpleGraph", "pipeline.xml"))
```

### Creating pipelines

Pipelines can be created using the `pipeline()` function, and its
associated helper functions. The resulting `pipeline` objects can be
executed using conduit, or saved to disk as XML files.

#### `pipeline()`

The `pipeline` function requires a `name` argument. The following arguments
can also be provided:

  + `path`: (Optional) Search path(s) for components associated with this
    pipeline.
  + `description`: A text description of what the pipeline does.
  + `components`: a list of the pipelines components. These must be 
    `module` or `pipeline` objects (or both). If this argument is empty the
    pipeline's components will be taken from the following arguments:
     - `modules`: a list of `module` objects.
     - `pipelines`: a list of `pipeline` objects.
  + `pipes`: a list of `pipe` objects.

Example:


```r
createGraph <- loadModule("createGraph", 
                          file.path("simpleGraph", "createGraph.xml"))
layoutGraph <- loadModule("layoutGraph",
                          file.path("simpleGraph", "layoutGraph.xml"))
pipe1 <- pipe("createGraph", "directedGraph", "layoutGraph", "myGraph")
pipelineExample <- 
    pipeline(name = "example", 
             components = list(createGraph, layoutGraph),
             pipes = list(pipe1))
```

#### `addComponent()`
#### `pipe()`
#### `addPipe()`

### Executing pipeline components

#### `runPipeline()`
#### `runComponent()`
    
### Saving and exporting pipelines as XML files

#### `savePipeline()`
#### `exportPipeline()`


Case study: turning R scripts into modules and a pipeline
----------

Case study: turning something non-R into a module/pipeline
----------

----

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Guide to using conduit</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://canadia.co.nz/" property="cc:attributionName" rel="cc:attributionURL">Ashley Noel Hinton</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
