---
title: "[Spring] IoC 컨테이너 공식문서 번역 (Autowiring Collaborators)"
excerpt: "Autowiring 협력자"

categories:
  - Spring
tags:
  - [ioc]

toc: true
toc_sticky: true

date: 2023-06-03
last_modified_at: 2023-06-03
---

> 현재 [매일 공식 문서를 읽고 해석하는 챌린지](https://github.com/yeonise/daily-code-snippets)를 진행 중이며, 일주일 단위로 정리해 나가고 있습니다.

<br>

# 기록

- [Introduction to the Spring IoC Container and Beans](https://sully-tech.dev/spring/ioc-introduction/)
- [Container Overview](https://sully-tech.dev/spring/ioc-basics/)
- [Bean OverView](https://sully-tech.dev/spring/ioc-definition/)
- [Dependencies](https://sully-tech.dev/spring/ioc-dependencies/)
    - [Dependency Injection](https://sully-tech.dev/spring/ioc-factory-collaborators/)
    - [Dependencies and Configuration in Detail](https://sully-tech.dev/spring/ioc-factory-properties-detailed/)
    - [Using depends-on](https://sully-tech.dev/spring/ioc-factory-dependson/)
    - [Lazy-initialized Beans](https://sully-tech.dev/spring/ioc-factory-lazy-init/)
    - [Autowiring Collaborators](https://sully-tech.dev/spring/ioc-factory-autowire/)

<br>

# Autowiring Collaborators

The Spring container can autowire relationships between collaborating beans. You can let Spring resolve collaborators (
other beans) automatically for your bean by inspecting the contents of the ApplicationContext. Autowiring has the
following advantages:

> 스프링 컨테이너는 협업하는 빈 간의 관계를 `autowire` 할 수 있습니다. `ApplicationContext`의 내용을 검사하여 스프링이 사용자의 빈에 대해 `collaborators`(다른 빈)를
> 자동으로 해결하도록 할 수 있습니다. `autowiring`에는 아래와 같은 이점이 있습니다:

- Autowiring can significantly reduce the need to specify properties or constructor arguments. (Other mechanisms such as
  a bean template discussed elsewhere in this chapter are also valuable in this regard.)
- Autowiring can update a configuration as your objects evolve. For example, if you need to add a dependency to a class,
  that dependency can be satisfied automatically without you needing to modify the configuration. Thus autowiring can be
  especially useful during development, without negating the option of switching to explicit wiring when the code base
  becomes more stable.

> - `autowiring`을 사용하여 속성이나 생성자 인수를 지정할 필요성을 크게 줄일 수 있습니다. (이 섹션의 다른 곳에서 설명하는 bean 템플릿과 같은 다른 메커니즘도 이와 관련하여 유용합니다.)
> - `autowiring`은 객체가 발달함에 따라 구성을 업데이트할 수 있습니다. 예를 들어 클래스에 의존성을 추가해야 하는 경우, 구성을 수정할 필요 없이 해당 의존성을 자동으로 충족할 수 있습니다.
    따라서 `autowiring`은 코드 기반이 안정화되면 분명한 `wiring`을 스위칭하는 옵션을 무효화하지 않고, 특히 개발 중에 유용할 수 있습니다.

<br>

When using XML-based configuration metadata (see Dependency Injection), you can specify the autowire mode for a bean
definition with the autowire attribute of the <bean/> element. The autowiring functionality has four modes. You specify
autowiring per bean and can thus choose which ones to autowire. The following table describes the four autowiring modes:

> XML-기반 구성 메타데이터를 사용하는 경우(의존성 주입 참조), `<bean/>` 요소의 `autowire` 속성을 사용하여 bean 정의에 대한 `autowire` 모드를 지정할 수
> 있습니다. `autowiring` 기능에는 네 가지 모드가 있습니다. `bean`별로 `autowiring`를 지정하여 어떤 `bean`을 `autowire`할지 선택할 수 있습니다. 아래의 표에서는 네
> 가지 `autowiring` 모드에 대해 설명합니다.

<br>

| Mode          | Explanation                                                                                                                                                                                                                                                                                                                                   |
|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `no`          | (Default) No autowiring. Bean references must be defined by ref elements. Changing the default setting is not recommended for larger deployments, because specifying collaborators explicitly gives greater control and clarity. To some extent, it documents the structure of a system.                                                      |
| `byName`      | Autowiring by property name. Spring looks for a bean with the same name as the property that needs to be autowired. For example, if a bean definition is set to autowire by name and it contains a master property (that is, it has a setMaster(..) method), Spring looks for a bean definition named master and uses it to set the property. |
| `byType`      | Lets a property be autowired if exactly one bean of the property type exists in the container. If more than one exists, a fatal exception is thrown, which indicates that you may not use byType autowiring for that bean. If there are no matching beans, nothing happens (the property is not set).                                         |
| `constructor` | Analogous to byType but applies to constructor arguments. If there is not exactly one bean of the constructor argument type in the container, a fatal error is raised.                                                                                                                                                                        |

> | Mode          | Explanation                                                                                                                                                                                                        |
>|---------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
>| `no`          | (기본값) `autowiring` 없음. bean 참조는 `ref` 요소로 정의해야 합니다. `collaborators`를 명시적으로 지정하면 제어 및 명확성이 향상되므로, 대규머 배포의 경우 기본 설정을 변경하는 것은 권장되지 않습니다. 어느 정도는 시스템의 구조를 문서화합니다.                                                      |
>| `byName`      | 프로퍼티 이름으로 `autowiring` 함. 스프링은 `autowire`해야 하는 프로퍼티와 이름이 같은 bean을 찾습니다. 예를 들어, bean 정의가 이름으로 `autowire` 되도록 설정되어 있고, `master` 프로퍼티가 포함된 경우(즉, `setMaster(..) 메서드) 스프링은 `master`라는 bean 정의를 찾아서 프로퍼티를 설정하는 데 사용합니다. |
>| `byType`      | 컨테이너에 프로퍼티 유형의 bean이 정확히 하나만 존재하는 경우, 프로퍼티를 `autowire`할 수 있습니다. 두 개 이상 존재하면, 치명적인 예외가 발생하며, 이는 해당 bean에 대해 `byType` `autowiring`을 사용할 수 없음을 나타냅니다. 일치하는 bean이 없으면 아무 일도 일어나지 않습니다(프로퍼티가 설정되지 않음).                  |
>| `constructor` | `byType`과 유사하지만, 생성자 인자에 적용됩니다. 컨테이너에 생성자 인자 유형의 bean이 정확히 하나도 없으면 치명적인 에러가 발생합니다.                                                                                                                                 |

<br>

With byType or constructor autowiring mode, you can wire arrays and typed collections. In such cases, all autowire
candidates within the container that match the expected type are provided to satisfy the dependency. You can autowire
strongly-typed Map instances if the expected key type is String. An autowired Map instance’s values consist of all bean
instances that match the expected type, and the Map instance’s keys contain the corresponding bean names.

> `byType` 또는 `constructor` `autowiring` 모드를 사용하면, 배열과 타입이 지정된 컬렉션을 `wire`할 수 있습니다. 이러한 경우, 컨테이너 내에서 예상 유형과 일치하는
> 모든 `autowire` 후보가 의존성을 충족하기 위해 제공됩니다. 예상 키 타입이 `String`이 ㄴ경우, 강력하게 유형화된 `Map` 인스턴스를 `autowire`할 수 있습니다. `autowire`
> 된 `Map` 인스턴스의 값은 예상 타입과 일치하는 모든 빈 인스턴스로 구성되며, `Map` 인스턴스의 키에는 해당 bean 이름이 포함됩니다.

<br>

# Limitations and Disadvantages of Autowiring

다음 이 시간에..

<br>

# Reference

- [Spring 공식 문서](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#spring-core)