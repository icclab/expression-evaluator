# expression-evaluator
A micro-service to enable on the fly expression evaluation.

# motivation
ETSI has specified the guidelines for virtual network function (VNF) descriptors and network service (NS) descriptors. These descriptors can be extended to contain assurance expressions and monitoring paramaters for constitutent VNFs of the NS. For NS orchestration, especially if the orchestrator design is influenced by micro-services design pattern, a small service that quickly evaluates these ETSI compliant VNF assurance expressions can be handy.

# supported expressions
This micro-service provides a REST API for on-the-fly expression evaluation, the expression must be a well formed functional composition. You can think of it as synonimous to a prefix expression. Parameters and constants are allowed, and the parameters values to be used in the expression must be supplied with the API call for evaluation.

Any well formed composed function expression is supported (to any depth)- 

```fn-x(p1, p2, fn-y(q1, q2, fn-z(r1, r2, r3)))```

The parameter list must be passed in the order they appear in the expression as a JSON array.

## example expressions
### vnf availability
GT(min(vnfs[1].availability, vnfs[2].availability))
### ns ram consumption
LT(add(vnfs[1].memory-consumption, vnfs[2].memory-consumption, 100))

# current functions support

1. ```add()``` - sum of parameters
2. ```min()``` - minimum value selection from the argument list
3. ```max()``` - maximum value selection from the argument list
4. ```avg()``` - average of the parameters
5. ```lt()``` - true if the argument is less than a threshold - threshold value is provided separately
6. ```gt()``` - true if the argument is greater than a threshold - threshold value is provided sepaately

# installation requirements
* Java runtime environemt (7.0 or higher)
* maven 3.0 or higher

# one-step installation steps (ubuntu or debian system)
* download the setup script - https://raw.githubusercontent.com/piyush82/expression-evaluator/master/setup.sh
* make the script executable - ```chmod +x setup.sh```
* execute the script - ```./setup.sh```
* follow the prompts and you are done. You will be prompted to provide certain inputs during the script execution. See configuration parameters section below.

# configuration parameters
* log file location - when prompted do provide the full path of the log file in the log4j configuration file. The field to be modified is ```log4j.appender.file.File```.
* database file location - when prompted, provide the full path of the sqlite database file, the field in expressionsolver.conf file is ```dbfile```.
* ```showexceptions``` - if set to true, the exceptions stack trace will be dumped otherwise exceptions will be supressed.
* ```port``` - the port number where the service will be running.
* ```dbengine``` - currently only sqlite is supported, in future other backends will be supported.

# currently supported API
The expression evaluator currently only supports stateless evaluations, but this will change in future where expressions can be registered with the service, and later invoked with full or partial parameter list.

In any API call, ```Content-Type``` header field must be provided. Currently supported type is ```application/json```.

## ip-address:port/exp-eval/otfly/ [POST] - example

```curl -X POST http://localhost:8000/exp-eval/otfly/ --header "Content-Type:application/json" -d '{"exp":"GT(min(vnfd[0].availability, vnfd[1].availability))", "values":["200.1", "109.58"], "threshold":"95"}'```

The parameter values are provided as a JSON array. Keep in mind even numbers are passed as string in the array.

Sample response if all goes as planned (HTTP Status Code: 200)- 
<pre>
{
    "result": "true",
    "info": "t-nova expression evaluation service",
    "status": "ok"
}
</pre>
If expression evaluation fails due to malformed expression or missing parameter value, the response will look like (with HTTP Status Code: 400) -
<pre>
{
  "msg": "malformed request parameters, check your expression or parameter list for correctness.",
  "info": "t-nova expression evaluation service",
  "status": "execution failed"
}
</pre>

## ip-address:port/kpi [GET]
This API call allows one to get some of the system counters. Currently, this call also resets the counters. But this will change very soon. The response body exaple is below.
<pre>
{
 "msg": "kpi parameters data",
 "data-since": "2015-11-05 17:38:18 GMT+01:00",
 "src": "t-nova expression evaluation service",
 "api-calls-failed": 0,
 "expressions-under-evaluation": 0,
 "api-calls-total": 5,
 "api-calls-success": 5,
 "expressions-evaluated": 0
}
</pre>


# need more info or want to contribute
Please contact me at ```piyush DOT harsh AT zhaw DOT ch```.

## License

this software is licensed under the
[Apache License version 2.0](https://www.apache.org/licenses/LICENSE-2.0).
See the file LICENSE.

# Made by

<div align="center" >
<a href='http://blog.zhaw.ch/icclab'>
<img src="https://raw.githubusercontent.com/icclab/hurtle/master/docs/figs/icclab_logo.png" title="hurtle" width=400px>
</a>
</div>
