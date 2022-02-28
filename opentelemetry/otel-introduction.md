# OpenTelemetry 简介

可观察性的每一次旅程都始于检测应用程序以在执行时从每个服务发出遥测数据——主要是logs、metrics 和 traces。OpenTelemetry 是云原生计算基金会( CNCF )下的一个开源项目，它提供了一个用于生成(generating)、收集(collecting)和传输(transmitting)遥测数据(telemetry data)的统一框架。使用 OpenTelemetry，可以以与供应商无关的方式检测应用程序，然后在您选择的后端工具中分析遥测数据，无论是 Prometheus、Jaeger、Zipkin 还是其他工具。本文中将介绍：  

  - [OpenTelemetry 概述](#opentelemetry-概述)：信号(signals)、客户端库(client libraries)、协议(protocol)、收集器(collector)等。 
  - [OpenTelemetry 当前状态](#opentelemetry-当前状态)：什么是 GA，什么是 Beta，什么是预期
  - [Service Instrumentation 的基本概念](#service-instrumentation-the-basic-concepts)：什么是 span ，什么是上下文
  - [自动与手动 Instrumentation](#自动与手动-instrumentation)
  - [支持的编程语言](#支持的编程语言)
  - [Instrumentation 建议](#instrumentation-建议)
  - [参考资源](#参考资源)

## OpenTelemetry 概述
什么是 OpenTelemetry？

OpenTelemetry（非正式地称为 OTEL 或 OTel）是一个可观察性框架——帮助从云原生软件生成和捕获遥测数据的软件和工具。

**OpenTelemetry 旨在处理 trace、metric 和 logs 之间**全面的观察性问题。

OpenTelemetry 是一个社区驱动的开源项目，它是 OpenTracing 和 OpenCensus 项目合并的结果。截至 2021 年 8 月，OpenTelemetry 是 CNCF 孵化项目。事实上，最近的CNCF 开发统计数据显示，OpenTelemetry 是仅次于 Kubernetes 的第二个最活跃的 CNCF 项目。

OpenTelemetry 提供了几个组件，最值得注意的是：

  - 每种编程语言的[API 和 SDK](#opentelemetry-api-sdk-规范)，用于生成和发出遥测数据
  - 用于接收(receive)、处理(process)和导出(export)遥测(telemetry)数据的收集器组件
  - 用于传输遥测数据的[OTLP协议](https://github.com/open-telemetry/opentelemetry-proto)

我们将在以下各节中逐一介绍。  

![](https://dytvr9ot2sszz.cloudfront.net/wp-content/uploads/2021/07/Group-1355-1024x211.png)


## OpenTelemetry API & SDK 规范
OpenTelemetry 为每种编程语言提供了一个API和一个SDK（一个OpenTelemetry 客户端 库），您可以使用它们手动检测您的应用程序以生成metric和trace遥测数据。

标准 API 确保在不同 SDK 实现之间切换时无需更改代码。 

SDK 负责采样、上下文传播和其他所需的处理，然后将数据导出到 OpenTelemetry Collector（见下文）。OpenTelemetry SDK 可以使用一套支持多种数据格式的 SDK 导出器将数据发送到其他目的地。

OpenTelemetry 还支持与流行框架、库、存储客户端等的集成以及自动检测代理的自动检测。这减少了应用程序中捕获metric和trace等内容所需的手动编码。

OpenTelemetry 规范定义了 API 和 SDK 的跨语言要求，以及围绕语义转换和协议的数据规范。


## 开放遥测收集器
OpenTelemetry Collector 可以从 OpenTelemetry SDK 和其他来源收集数据，然后将此遥测数据导出到任何支持的后端，例如 Jaeger、Prometheus 或 Kafka 队列。 

OpenTelemetry Collector 既可以用作与应用程序位于同一主机上的本地代理，也可以用作跨多个应用程序节点聚合的中央收集器服务。

![OpenTelemetry 收集器架构](https://dytvr9ot2sszz.cloudfront.net/wp-content/uploads/2021/07/scheme-1-1024x356.png)

OpenTelemetry Collector 构建为可插拔架构中的处理管道，具有三个主要部分：

  1. 用于接收各种格式和协议的传入数据的接收器，例如 OTLP、Jaeger 和 Zipkin。[您可以在此处](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver)找到可用接收器的列表。
  2. 用于对每种信号类型执行数据聚合、过滤、采样和其他收集器处理逻辑的处理器。例如， SpanMetrics Processor 可以[聚合来自 spans](https://horovits.medium.com/from-distributed-tracing-to-apm-taking-opentelemetry-and-jaeger-up-a-level-12dfe85022da) 的metric。处理器可以链接起来以产生复杂的处理逻辑。
  3. 用于以各种格式和协议（例如 OTLP、Prometheus 和 Jaeger）将遥测数据发送到一个或多个后端目的地（通常是分析工具或更高阶聚合器）的导出器。[您可以在此处](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter)找到可用的出口商列表。
 

#### OTLP: 开放遥测协议
那么什么是 OTLP？

OpenTelemetry 定义了一个与供应商和工具无关的协议规范，称为 OTLP（OpenTelemetry 协议），用于传输trace、度量和日志遥测数据。有了这些，替换后端分析工具就像在收集器上更改配置一样简单。

OTLP 可用于将遥测数据从 SDK 传输到收集器，以及从收集器传输到选择的后端工具。OTLP 规范定义了数据的编码、传输和交付机制，是面向未来的选择。 

但是，您的系统可能正在使用第三方工具和框架，这些工具和框架可能附带 OTLP 以外的内置工具，例如 Zipkin 或 Jaeger 格式。OpenTelemetry Collector 可以使用上述适当的接收器来摄取这些其他协议。

[您可以在此处](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/overview.md)找到 OpenTelemetry 组件的详细规范。

## OpenTelemetry: 当前状态
Opentelemetry 是多个组的集合，每个组都致力于这项巨大努力的不同组成部分：不同的组处理不同遥测信号的规范——分布式trace、logs 和 metric，不同的组专注于不同的编程语言特定客户端，仅举几例。每个组都有自己的发布节奏，这意味着 OpenTelemetry 的不同组件可能处于成熟度生命周期的不同阶段：

**Draft → Experimental → Stable → Deprecated**.

Stable 相当于 GA（generally available），可用在生产环境。Experimental 则处于 Beta 阶段，用来评估和 PoC(Proof of Concept)测试。

在为您的项目评估 OpenTelemetry 时，您应该映射系统相关组件的状态：

  1. 感兴趣的数据类型（traces/metrics/logs）
  2. 接收数据类型的协议
  3. 您使用的编程语言的客户端库。也可能是用于检测您在代码中使用的编程框架的代理。


让我们从API 和 SDK 规范的状态开始：

  - 从[v1.0.0 版本开始](https://medium.com/opentelemetry/opentelemetry-specification-v1-0-0-tracing-edition-72dd08936978)，trace 规范就处于stable状态 ，它建立在 OpenTracing 的坚实基础之上。 
  - 根据[路线图](https://medium.com/opentelemetry/opentelemetry-metrics-roadmap-f4276fd070cf)，metric规范预计将在 2021 年底达到 v1.0 GA（稳定状态），兼容 OpenCensus，以及完全兼容 Prometheus 和 OpenMetrics。 
  - 日志记录规范是最不先进的，预计不会在 2022 年之前。
  - [不推荐使用](https://github.com/opentracing/specification/issues/163)OpenTracing和OpenCensus API ，取而代之的是 OpenTelemetry API。

**OTLP**对每个信号也有单独的生命周期：目前，OTLP 在trace和度量 方面处于Stable状态，在日志记录方面处于 Experimental 状态。

**不同语言的SDK（客户端库**）是独立开发的，因此具有不同的成熟度级别。例如，在撰写本文时，Java SDK 已经处于 GA[版本 1.4.1](https://github.com/open-telemetry/opentelemetry-java/releases/)，而 GoLang SDK 仍处于候选版本 1 ( [v1.0.0-RC1](https://github.com/open-telemetry/opentelemetry-go/releases/) )。请参阅以下部分以了解支持的编程语言并查看与您相关的堆栈状态。

**OpenTelemetry Collector**已于 2021 年 9 月达到 GA trace，预计 Metrics 将在 2021 年底达到 GA，Logging 仍处于试验阶段。

[您可以在 OpenTelemetery状态页面](https://opentelemetry.io/status/)中找到高级状态信息。


## Service Instrumentation: The Basic Concepts
当分布式跟踪(distributed tracing)检测服务(Service Instrumentation) 时,对服务的每次操作调用都会发出一个span（在某些情况下是多个spans）。 

您可以使用 API 和 SDK（有时称为trace器的客户端库）在代码中手动创建span。在某些情况下，您还可以使用 auto-instrumentation 来自动生成span，这样您的应用程序中就不需要更改代码。

span 包含有关调用的服务和操作的数据、调用开始和完成时间戳、span 上下文（trace id、span id、父 span id 等）以及用户定义属性的可选列表（本质上是键值对） ）。SDK 负责通过相关服务传播上下文，以确保捕获 span 之间的因果关系。

然后将 span 格式化为特定协议并通过 SDK 发送到收集器后端（通常通过代理或收集器组件），然后从那里发送到trace分析后端工具，例如 Jaeger。 

span在后端被摄取和收集，并根据因果关系从span中重构trace，即调用顺序。 

这是一个非常基本的大纲。我遗漏了许多与instrumentation不直接相关的细节。现在让我们深入研究如何检测我们的应用程序。


## 自动与手动 Instrumentation
Instrumentation 是我们的服务发出带有适当上下文的格式良好的 span 的能力。但是我们如何生成这些span？ 

您可以手动检测您的应用程序，通过添加代码来开始和结束span（指定执行代码块的开始和结束时间戳），指定有效负载并提交span数据。 

一些软件框架和代理提供自动检测，这使您无需为许多用例修改应用程序代码，并且可以提供基线遥测。 

自动和手动不是相互排斥的选项。事实上，建议将两者结合起来，尽可能利用无代码方法的优势，并在需要时进行细粒度控制。

让我们看看如何使用手动和自动检测来检测您的代码，以及为您的需求选择正确检测方法的注意事项。

#### 手动 Instrumentation
手动插桩意味着开发人员需要向应用程序添加代码以启动和完成span并定义有效负载。它利用了客户端库和 SDK，它们可用于各种不同的编程语言，我们将在下面看到。 

让我们看看手动检测我们的应用程序的注意事项：

**优点**
  - 这是应用程序堆栈中不支持自动检测的唯一选项
  - 手动检测可让您最大限度地控制正在生成的数据。
  - 您可以检测自定义代码块
  - 允许在trace中捕获业务指标或其他自定义指标，包括您要用于监控或业务可观察性的事件或消息。 

**缺点**
  - 这很耗时。
  - 有一个学习曲线来完善它。
  - 可能会导致性能开销。
  - 更多的人为错误导致span上下文中断。
  - 更改instrumentation可能需要重新编译应用程序


#### 自动 Instrumentation

自动检测不需要更改代码，也不需要重新编译应用程序。此方法使用附加到正在运行的应用程序并提取trace数据的智能代理。 

您还可以找到适用于 Python、Java、.NET 和 PHP 等流行编程语言的自动检测代理。此外，这些语言的通用库和框架还提供内置工具。

例如，**Java程序员可以利用自动注入字节码的**[Java 代理](https://github.com/open-telemetry/opentelemetry-java-instrumentation)来捕获基线遥测数据，而无需更改应用程序的 Java 源代码。Java 程序员还可以为Spring、JDBC、RxJava、Log4J 等几个流行的库  找到[独立的工具](https://github.com/open-telemetry/opentelemetry-java-instrumentation/blob/main/docs/standalone-library-instrumentation.md)。

有一些方法可以减少编码工具，例如通过 Sidecar代理的[服务网格，以及通过 Linux 内核工具的eBPF](https://logz.io/blog/what-is-a-service-mesh-kubernetes-istio/)，我们将无法在本介绍范围内讨论。

如果您使用 Django、Hibernate 和 Sequelize 等 ORM 库，则可以使用[SQLCommenter]https://github.com/google/sqlcommenter（由 Google 于 2021 年 9 月向 OpenTelemetry 贡献）来自动检测这些库并启用以应用程序为中心的数据库可观察性。

让我们看看自动检测应用程序的注意事项：

**优点**
  - 不需要更改代码。
  - 提供对应用程序端点和操作的良好覆盖。
  - 节省检测代码的时间，让您专注于业务。
  - 减少因instrumentation更新而对代码更改的需求（例如在有效负载中捕获的新元数据） 
**缺点**
  - 并非所有语言和框架都提供自动检测
  - 提供的灵活性低于手动检测，通常在函数或方法调用的范围内
  - 仅检测有关使用情况和性能的基本指标。业务指标或其他自定义指标需要手动检测
  - 通常仅根据trace中的相关事件或日志捕获错误数据。


## 支持的编程语言

OpenTelemetry 目前为以下编程语言提供 SDK： 
  - [java](https://github.com/open-telemetry/opentelemetry-java)
  - [.net](https://github.com/open-telemetry/opentelemetry-dotnet)
  - [c++](https://github.com/open-telemetry/opentelemetry-cpp)
  - [go](https://github.com/open-telemetry/opentelemetry-go)
  - [python](https://github.com/open-telemetry/opentelemetry-python)
  - [node.js](https://logz.io/blog/nodejs-javascript-opentelemetry-auto-instrumentation/)
  - [php](https://github.com/open-telemetry/opentelemetry-php)
  - [ruby](https://github.com/open-telemetry/opentelemetry-ruby)
  - [rust](https://github.com/open-telemetry/opentelemetry-rust)
  - [swift](https://github.com/open-telemetry/opentelemetry-swift)
  - [erlang](https://github.com/open-telemetry/opentelemetry-erlang)

某些语言还具有用于自动 Instrumentation 的代理，这可以加快您的检测工作。

## Instrumentation 建议
以下是一些有用的instrumentation指南：

  1. **确定应用程序堆栈中提供内置检测**并启用其检测基础设施基线trace的工具。对于每一个，验证它以哪种格式和协议导出trace数据，并确保您可以摄取这种格式（使用适当的接收器）
  2. **尽可能利用自动Instrumentation**。为您的编程语言使用代理，这些代理可以自己或通过您使用的软件框架、库和中间件生成trace数据。
  3. 一旦充分使用开箱即用的功能，就可以绘制出检测数据和可观察性中的差距，并**根据需要增加手动检测**。从您绘制的最突出的差距开始，逐步进行。通常从面向客户端的服务和端点开始，然后添加更多后端服务很有用。
  4. **验证您使用的每个组件的发布和成熟度级别**，无论是收集器、客户端库、协议还是其他组件，因为每个组件都有自己的发布生命周期。

注意：请注意 OpenTracing 已被弃用，建议迁移到 OpenTelemetry。

## 参考资源

- [OTEL guide](https://logz.io/learn/opentelemetry-guide)
- [opentelemetry.io](https://opentelemetry.io/)
- [OTEL overview](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/overview.md)
- [OTEL status](https://opentelemetry.io/status/)
- [OTEL 使命](https://github.com/open-telemetry/community/blob/main/mission-vision-values.md)
- [媒体眼里的OTEL](https://medium.com/opentelemetry)
- [Jeager & OpenTracing](https://logz.io/blog/jaeger-instrumentation-introduction/)
- [使用eBPF进行检测](https://logz.io/blog/ebpf-auto-instrumentation-pixie-kubernetes-observability/)
- [OTEL 规范进入 GA](https://medium.com/opentelemetry/opentelemetry-specification-v1-0-0-tracing-edition-72dd08936978)
- [从分布式trace到APM: 让OTEL和Jaeger更上一层楼](https://logz.io/blog/monitoring-microservices-opentelemetry-jaeger/)
- [使用OTEL和Jaeger跟踪Java程序](https://logz.io/blog/java-instrumentation-tracing/)
- https://otel.help/
- [OTEL成为 CNCF 孵化项目](https://www.cncf.io/blog/2021/08/26/opentelemetry-becomes-a-cncf-incubating-project/)
- [OTEL collector 达到 Tracing 稳定性里程碑](https://medium.com/opentelemetry/opentelemetry-collector-achieves-tracing-stability-milestone-80e34cadbbf5)
- [OTLP](https://github.com/open-telemetry/opentelemetry-proto)
