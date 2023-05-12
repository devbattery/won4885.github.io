---
title: "[Spring] IoC 컨테이너 공식문서 번역 (Dependencies)"
excerpt: "의존성"

categories:
  - Spring
tags:
  - [ioc]

toc: true
toc_sticky: true

date: 2023-05-12
last_modified_at: 2023-05-12
---

> 현재 [매일 공식 문서를 읽고 해석하는 챌린지](https://github.com/yeonise/daily-code-snippets)를 진행 중이며, 이를 일주일 단위로 계속 정리해나가는 중입니다.

<br>

## 기록

- [IoC 컨테이너 공식문서 번역 (Introduction to the Spring IoC Container and Beans)](https://sully-tech.dev/spring/ioc-introduction/)
- [IoC 컨테이너 공식문서 번역 (Container Overview)](https://sully-tech.dev/spring/ioc-basics/)
- [IoC 컨테이너 공식문서 번역 (Bean OverView)](https://sully-tech.dev/spring/ioc-definition/)

<br>

## Reference

- [Spring 공식 문서](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#spring-core)

<br>

# Dependencies

A typical enterprise application does not consist of a single object (or bean in the Spring parlance). Even the simplest
application has a few objects that work together to present what the end-user sees as a coherent application. This next
section explains how you go from defining a number of bean definitions that stand alone to a fully realized application
where objects collaborate to achieve a goal.

> 일반적인 엔터프라이즈 애플리케이션은 단일 객체(또는 스프링 용어로 빈)로 구성되지 않습니다. 가장 단순한 애플리케이션조차도 최종 사용자에게 일관된 애플리케이션으로 보이기 위해 함께 작동하는 몇 가지 객체가
> 있습니다. 다음 섹션에서는 독립적으로 존재하는 여러 개의 빈 정의를 정의하는 것부터 객체들이 협업하여 목표를 달성하는 완전히 실현된 애플리케이션으로 전환하는 방법에 대해 설명합니다.

<br>

## Dependency Injection

Dependency injection (DI) is a process whereby objects define their dependencies (that is, the other objects with which
they work) only through constructor arguments, arguments to a factory method, or properties that are set on the object
instance after it is constructed or returned from a factory method. The container then injects those dependencies when
it creates the bean. This process is fundamentally the inverse (hence the name, Inversion of Control) of the bean itself
controlling the instantiation or location of its dependencies on its own by using direct construction of classes or the
Service Locator pattern.

> 종속성 주입(DI)은 객체가 생성자 인수와 팩토리 메서드에 대한 인수 또는 객체 인스턴스가 생성되거나, 팩토리 메서드에서 반환된 후 객체 인스턴스에 설정된 속성을 통해서만 의존성(즉, 함께 작동하는 다른 객체)을
> 정의하는 프로세스입니다. 그런 다음 컨테이너는 빈을 생성할 때 이러한 의존성을 주입합니다. 이 프로세스는 기본적으로 클래스의 직접 구성 또는 서비스 로케이터 패턴을 사용하여 빈 자체가 종속성의 인스턴스화 또는
> 위치를
> 자체적으로 제어하는 역방향(따라서 이름이 제어의 역전인 거임)입니다.

<br>

Code is cleaner with the DI principle, and decoupling is more effective when objects are provided with their
dependencies. The object does not look up its dependencies and does not know the location or class of the dependencies.
As a result, your classes become easier to test, particularly when the dependencies are on interfaces or abstract base
classes, which allow for stub or mock implementations to be used in unit tests.

> DI 원칙을 사용하면 코드가 더 깔끔해지며, 객체에 의존성이 제공될 때 디커플링이 더욱 효과적입니다. 객체는 의존성을 조회하지 않으며 의존성의 위치나 클래스를 알지 못합니다. 결과적으로 클래스를 테스트하기가 더
> 쉬워지며, 특히 의존성이 인터페이스나 추상 기본 클래스에 있는 경우, 단위 테스트에서 `stuc` 또는 `mock` 구현들을 할 수 있습니다.

<br>

DI exists in two major variants: Constructor-based dependency injection and Setter-based dependency injection.

> DI는 크게 두 가지 변형이 있습니다: 생성자 기반 의존성 주입과 세터 기반 의존성 주입입니다.

<br>

## Constructor-based Dependency Injection

Constructor-based DI is accomplished by the container invoking a constructor with a number of arguments, each
representing a dependency. Calling a static factory method with specific arguments to construct the bean is nearly
equivalent, and this discussion treats arguments to a constructor and to a static factory method similarly. The
following example shows a class that can only be dependency-injected with constructor injection:

> 생성자 기반 DI는 컨테이너가 각각 의존성을 나타내는 여러 개의 인자를 사용하여 생성자를 호출함으로써 수행됩니다. 특정 인수를 사용하여 `static` 팩토리 메서드를 호출하여 빈을 생성하는 것은 거의 동일하며,
> 이 설명에서는 생성자와 `static` 팩토리 메서드에 대한 인수를 유사하게 취급합니다. 아래의 예제에서는 생성자 주입으로만 의존성을 주입할 수 있는 클래스를 보여줍니다.

```java
public class SimpleMovieLister {

    // the SimpleMovieLister has a dependency on a MovieFinder
    // SimpleMovieListner는 MovieFinder에 대한 의존성이 있습니다
    private final MovieFinder movieFinder;

    // a constructor so that the Spring container can inject a MovieFinder
    // 생성자를 생성하여 스프링 컨테이너가 MovieFinder를 주입할 수 있도록 합니다.
    public SimpleMovieLister(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // business logic that actually uses the injected MovieFinder is omitted...
    // 실제로 삽입된 MovieFinder를 사용하는 비즈니스 로직은 생략쓰
}
```

Notice that there is nothing special about this class. It is a POJO that has no dependencies on container specific
interfaces, base classes, or annotations.

> 위 클래스에는 특별한 것이 없습니다. 컨테이너 특정 인터페이스, 기본 클래스 또는 어노테이션에 대한 의존성이 없는 POJO입니다.

<br>

### Constructor Argument Resolution

Constructor argument resolution matching occurs by using the argument’s type. If no potential ambiguity exists in the
constructor arguments of a bean definition, the order in which the constructor arguments are defined in a bean
definition is the order in which those arguments are supplied to the appropriate constructor when the bean is being
instantiated. Consider the following class:

> 생성자 인자 해결 매칭은 인자의 유형을 사용하여 발생합니다. 빈 정의의 생성자 인자에 잠재적인 모호성이 존재하지 않는 경우, 빈 정의에서 생성자 인자가 정의되는 순선느 빈이 인스턴스화 될 때 해당 인자가 적절한
> 생성자에게 제공되는 순서입니다. 아래의 클래스를 고려하세요:

```java
package x.y;

public class ThingOne {

    public ThingOne(ThingTwo thingTwo, ThingThree thingThree) {
        // ...
    }
}
```

Assuming that the ThingTwo and ThingThree classes are not related by inheritance, no potential ambiguity exists. Thus,
the following configuration works fine, and you do not need to specify the constructor argument indexes or types
explicitly in the <constructor-arg/> element.

> `ThingTwo`와 `ThingThree` 클래스가 상속으로 관련되지 않는다고 가정하면, 잠재적인 모호성은 존재하지 않습니다. 따라서 아래의 구성은 정상적으로 작동하며, `<constructor-arg/>`
> 요소에 생성자 인수 인덱스나 유형을 명시적으로 지정할 필요가 없습니다.

```xml

<beans>
    <bean id="beanOne" class="x.y.ThingOne">
        <constructor-arg ref="beanTwo"/>
        <constructor-arg ref="beanThree"/>
    </bean>

    <bean id="beanTwo" class="x.y.ThingTwo"/>

    <bean id="beanThree" class="x.y.ThingThree"/>
</beans>
```

When another bean is referenced, the type is known, and matching can occur (as was the case with the preceding example).
When a simple type is used, such as <value>true</value>, Spring cannot determine the type of the value, and so cannot
match by type without help. Consider the following class:

> 아래의 빈을 참조하면, 유형을 알 수 있으므로 위의 예제에서와 같이 일치시킬 수 있습니다.`<value>true</value>`와 같은 단순한 타입이 사용되는 경우, 스프링은 값의 타입을 확인할 수 없으므로 도움
> 없이는 타입별로 일치시킬 수 없습니다. 아래 클래스를 고려해 보세요:

```java
package examples;

public class ExampleBean {

    // Number of years to calculate the Ultimate Answer
    // 최종 정답을 계산하는 데 걸리는 연도 수
    private final int years;

    // The Answer to Life, the Universe, and Everything
    // 생명, 우주 그리고 모든 것에 대한 해답
    private final String ultimateAnswer;

    public ExampleBean(int years, String ultimateAnswer) {
        this.years = years;
        this.ultimateAnswer = ultimateAnswer;
    }
}
```

In the preceding scenario, the container can use type matching with simple types if you explicitly specify the type of
the constructor argument by using the type attribute, as the following example shows:

> 앞의 시나리오에서 컨테이너는 아래의 예제와 같이 유형 `type`을 사용하여 생성자 인수의 유형을 명시적으로 지정하는 경우, 단순 유형과 유형 일치를 사용할 수 있습니다.

```xml

<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg type="int" value="7500000"/>
    <constructor-arg type="java.lang.String" value="42"/>
</bean>
```

You can use the index attribute to specify explicitly the index of constructor arguments, as the following example
shows:

> 아래의 예제에서 볼 수 있듯이, `index` 속성을 사용하여 생성자 인수의 인덱스를 명시적으로 지정할 수 있습니다.

```xml

<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg index="0" value="7500000"/>
    <constructor-arg index="1" value="42"/>
</bean>
```

In addition to resolving the ambiguity of multiple simple values, specifying an index resolves ambiguity where a
constructor has two arguments of the same type.

> 인덱스를 지정하면 여러 단순 값의 모호성을 해결하는 것 외에도, 생성자에 동일한 유형의 인수가 두 개 있는 경우 모호성을 해결할 수 있습니다.

<br>

The index is 0-based.
{: .notice}

<br>

You can also use the constructor parameter name for value disambiguation, as the following example shows:

> 아래의 예제에서 볼 수 있듯이, 생성자 매개변수 이름을 사용하여 값의 모호성을 없앨 수도 있습니다.

```xml

<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg name="years" value="7500000"/>
    <constructor-arg name="ultimateAnswer" value="42"/>
</bean>
```

Keep in mind that, to make this work out of the box, your code must be compiled with the debug flag enabled so that
Spring can look up the parameter name from the constructor. If you cannot or do not want to compile your code with the
debug flag, you can use the @ConstructorProperties JDK annotation to explicitly name your constructor arguments. The
sample class would then have to look as follows:

> 이 기능을 바로 사용하려면, 스프링이 생성자에서 매개변수 이름을 조회할 수 있도록 디버그 플래그를 활성화한 상태로 코드를 컴파일해야 합니다. 디버그 플래그를 사용하여 코드를 컴파일할 수 없거나 원하지 않는
> 경우, `@ConstructorPreperties` JDK 어노테이션을 사용하여 생성자 인수의 이름을 명시적으로 지정할 수 있습니다. 그러면 샘플 클래스는 아래와 같이 보일 것입니다.

```java
package examples;

public class ExampleBean {

    // Fields omitted
    // 필드는 생략쓰

    @ConstructorProperties({"years", "ultimateAnswer"})
    public ExampleBean(int years, String ultimateAnswer) {
        this.years = years;
        this.ultimateAnswer = ultimateAnswer;
    }
}
```

<br>

## Setter-based Dependency Injection

Setter-based DI is accomplished by the container calling setter methods on your beans after invoking a no-argument
constructor or a no-argument static factory method to instantiate your bean.

> 세터 기반 DI는 컨테이너가 인수가 없는 생성자 또는 인수가 없는 `static` 팩토리 메서드를 호출하여 빈을 인스턴스화한 후 빈의 세터 메서드를 호출하여 수행됩니다.

<br>

The following example shows a class that can only be dependency-injected by using pure setter injection. This class is
conventional Java. It is a POJO that has no dependencies on container specific interfaces, base classes, or annotations.

> 아래의 예제는 순수 세터 주입을 사용해야만 의존성 주입이 가능한 클래스를 보여줍니다. 이 클래스는 기본 자바입니다. 컨테이너 특정 인터페이스 또는 어노테이션에 대한 의존성이 없는 POJO입니다.

```java
public class SimpleMovieLister {

    // the SimpleMovieLister has a dependency on the MovieFinder
    // SimpleMoiveLister는 MovieFinder에 대한 종속성이 있습니다.
    private MovieFinder movieFinder;

    // a setter method so that the Spring container can inject a MovieFinder
    // 세터 메서드를 추가하여 스프링 컨테이너가 MoiveFinder를 주입할 수 있도록 합니다.
    public void setMovieFinder(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // business logic that actually uses the injected MovieFinder is omitted...
    // 삽입된 MovieFinder를 실제로 사용하는 비즈니스 로직은 생략쓰
}
```

<br>

The ApplicationContext supports constructor-based and setter-based DI for the beans it manages. It also supports
setter-based DI after some dependencies have already been injected through the constructor approach. You configure the
dependencies in the form of a BeanDefinition, which you use in conjunction with PropertyEditor instances to convert
properties from one format to another. However, most Spring users do not work with these classes directly (that is,
programmatically) but rather with XML bean definitions, annotated components (that is, classes annotated with
@Component, @Controller, and so forth), or @Bean methods in Java-based @Configuration classes. These sources are then
converted internally into instances of BeanDefinition and used to load an entire Spring IoC container instance.

> `ApplicationContext`는 관리하는 빈에 대해 생성자 기반 및 세터 기반 DI를 지원합니다. 또한 생성자 접근 방식을 통해 일부 의존성이 이미 주입된 후에도 세터 기반 DI를 지원합니다.
> 의존성을 `BeanDefiniton`의 형태로 구성하고, 이를 `PropertyEditor` 인스턴스와 함께 사용하여 속성을 한 형식에서 다른 형식으로 변환합니다. 그러나 대부분의 스프링 사용자는 이러한 클래스를
> 직접(즉, 프로그래밍 방식으로) 사용하는 것이 아니라 XMl 빈 정의, 주석이 달린 컴포넌트(즉, `@Component`, `@Controller` 등으로 주석이 달린 클래스) 또는 자바
> 기반 `@Configuration` 클래스의 `@Bean` 메서드를 사용하여 작업합니다. 그런 다음 이러한 소스는 내부적으로 `BeanDefinition`의 인스턴스로 변환되어 전체 스프링 IoC 컨테이너
> 인스턴스를
> 로드하는 데 사용됩니다.

<br>

### Constructor-based or setter-based DI?

Since you can mix constructor-based and setter-based DI, it is a good rule of thumb to use constructors for mandatory
dependencies and setter methods or configuration methods for optional dependencies. Note that use of the @Autowired
annotation on a setter method can be used to make the property be a required dependency; however, constructor injection
with programmatic validation of arguments is preferable.

> 생성자 기반과 세터 기반 DI를 혼합할 수 있으므로 필수 의존성에는 생성자를 사용하고, 선택적 의존성에는 세터 메서드 또는 구성 메서드를 사용하는 것이 좋습니다. 세터 메서드에 `@Autowired` 어노테이션을
> 사용하여 프로퍼티를 필수 의존성으로 만들 수 있지만, 인자의 프로그래밍 방식 유효성 검사가 포함된 생성자 주입을 사용하는 것이 좋습니다.

<br>

The Spring team generally advocates constructor injection, as it lets you implement application components as immutable
objects and ensures that required dependencies are not null. Furthermore, constructor-injected components are always
returned to the client (calling) code in a fully initialized state. As a side note, a large number of constructor
arguments is a bad code smell, implying that the class likely has too many responsibilities and should be refactored to
better address proper separation of concerns.

> 스프링 팀은 일반적으로 생성자 주입을 지지하는데, 이는 애플리케이션 컴포넌트를 불변 객체로 구현하고, 필요한 의존성이 `null`이 되지 않도록 보장하기 때문입니다. 또한 생성자 주입 컴포넌트는 항상 완전히
> 초기화된 상태로 클라이언트(호출) 코드에 반환됩니다. 참고로, 생성자 인수가 많다는 것은 코드 냄새가 좋지 않다는 의미이며, 클래스에 너무 많은 책임이 있을 수 있으므로 적절한 분리를 위해 리팩토링해야 한다는
> 것을
> 의미합니다. 이럴 때 빌더 패턴 쓰면 되려나?

<br>

Setter injection should primarily only be used for optional dependencies that can be assigned reasonable default values
within the class. Otherwise, not-null checks must be performed everywhere the code uses the dependency. One benefit of
setter injection is that setter methods make objects of that class amenable to reconfiguration or re-injection later.
Management through JMX MBeans is therefore a compelling use case for setter injection.

> 세터 주입은 주로 클래스 내에서 합리적인 기본값을 할당할 수 있는 선택적 의존성에만 사용해야 합니다. 그렇지 않으면 코드가 의존성을 사용하는 모든 곳에서 `null`이 아닌지 검사를 수행해야 합니다. 세터 주입의
> 한 가지 이점은 세터 메서드를 사용하여 해당 클래스의 객체를 나중에 재구성하거나 다시 주입할 수 있다는 점입니다. 따라서 `JMX MBeans`를 통한 관리는 세터 주입의 강력한 사용 사례입니다. 이게 뭔디

<br>

Use the DI style that makes the most sense for a particular class. Sometimes, when dealing with third-party classes for
which you do not have the source, the choice is made for you. For example, if a third-party class does not expose any
setter methods, then constructor injection may be the only available form of DI.

> 특정 클래스에 가장 적합한 DI 스타일을 사용하세요. 소스가 없는 타사 클래스를 다룰 때는 어떤 스타일을 선택해야 할지 고민하는 경우가 있습니다. 예를 들어, 서드파티 클래스에 세터 메서드가 노출되지 않는 경우,
> 생성자 주입이 가능한 유일한 DI 형태일 수 있습니다.

<br>

추가 예정...