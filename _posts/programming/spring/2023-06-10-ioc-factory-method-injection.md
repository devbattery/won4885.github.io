---
title: "[Spring] IoC 컨테이너 공식문서 번역 (Method Injection)"
excerpt: "메서드 주입"

categories:
  - Spring
tags:
  - [ioc]

toc: true
toc_sticky: true

date: 2023-06-10
last_modified_at: 2023-06-10
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
    - [Method Injection](https://sully-tech.dev/spring/ioc-factory-method-injection/)

<br>

# Method Injection

In most application scenarios, most beans in the container are singletons. When a singleton bean needs to collaborate
with another singleton bean or a non-singleton bean needs to collaborate with another non-singleton bean, you typically
handle the dependency by defining one bean as a property of the other. A problem arises when the bean lifecycles are
different. Suppose singleton bean A needs to use non-singleton (prototype) bean B, perhaps on each method invocation on
A. The container creates the singleton bean A only once, and thus only gets one opportunity to set the properties. The
container cannot provide bean A with a new instance of bean B every time one is needed.

> 대부분의 애플리케이션 시나리오에서, 컨테이너의 대부분의 bean은 싱글톤입니다. 싱글톤 bean이 다른 싱글톤 bean과 협업해야 하거나 비싱글톤 bean이 다른 비싱글톤 bean과 엽헙해야 하는 경우,
> 일반적으로 한 bean을 다른 bean의 속성으로 정의하여 의존성을 처리합니다. 문제는 bean의 라이프사이클이 다를 때 발생합니다. 싱글톤 bean A가 A에서 메서드를 호출할 때마다 비싱글톤(프로토타입)
> bean
> B를 사용해야 한다고 가정해 보겠습니다. 컨테이너는 싱글톤 bean A를 한 번만 생성하므로, 속성을 설정할 기회는 한 번만 얻게 됩니다. 컨테이너는 필요할 때마다 bean A에 bean B의 새 인스턴스를
> 제공할
> 수 있습니다:

<br>

A solution is to forego some inversion of control. You can make bean A aware of the container by implementing the
ApplicationContextAware interface, and by making a getBean("B") call to the container ask for (a typically new) bean B
instance every time bean A needs it. The following example shows this approach:

> 한 가지 해결책은 `IoC`를 포기하는 것입니다. bean A가 컨테이너를 인식하게 하려면 `ApplicationContextAware` 인터페이스를 구현하고, bean A가 필요할 때마다 컨테이너에
> 대한 `getBean("B")` 호출이 (일반적으로 새로운) bean B 인스턴스를 요청하도록 하면 됩니다. 아래의 예제는 이 접근 방식을 보여줍니다:ㅣ

```java
package fiona.apple;

// Spring-API imports
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * A class that uses a stateful Command-style class to perform
 * some processing.
 * stateful 커맨드-스타일 클래스를 사용하여 일부 처리를 수행하는 클래스
 */
public class CommandManager implements ApplicationContextAware {

	private ApplicationContext applicationContext;

	public Object process(Map commandState) {
		// grab a new instance of the appropriate Command
		// 해당 명령의 새 인스턴스를 가져옵니다
		Command command = createCommand();
		// set the state on the (hopefully brand new) Command instance
		// (새로운) 커맨드 인스턴스에 상태를 설정합니다.
		command.setState(commandState);
		return command.execute();
	}

	protected Command createCommand() {
		// notice the Spring API dependency!
		// 스프링 API 의존성에 주목!
		return this.applicationContext.getBean("command", Command.class);
	}

	public void setApplicationContext(
			ApplicationContext applicationContext) throws BeansException {
		this.applicationContext = applicationContext;
	}
}
```

The preceding is not desirable, because the business code is aware of and coupled to the Spring Framework. Method
Injection, a somewhat advanced feature of the Spring IoC container, lets you handle this use case cleanly.

> 비즈니스 코드가 스프링 프레임워크를 인식하고 스프링 프레임워크에 결합되어 있기 때문에 위의 방법은 바람직하지 않습니다. 스프링 IoC 컨테이너의 다소 고급 기능인 메서드 주입을 사용하면 위 코드를 깔끔하게 처리할
> 수 있습니다.

<br>

You can read more about the motivation for Method Injection in this blog entry.
{: .notice--primary}

> 메서드 주입에 대한 자세한 내용은 [이 블로그](https://spring.io/blog/2004/08/06/method-injection)에서 확인할 수 있습니다.

<br>

## Lookup Method Injection

Lookup method injection is the ability of the container to override methods on container-managed beans and return the
lookup result for another named bean in the container. The lookup typically involves a prototype bean, as in the
scenario described in the preceding section. The Spring Framework implements this method injection by using bytecode
generation from the CGLIB library to dynamically generate a subclass that overrides the method.

> Lookup 메서드 주입은 컨테이너가 컨테이너 관리 bean의 메서드를 재정의하고, 컨테이너의 다른 명명된 bean에 대한 조회 결과를 반환하는 컨테이너의 기능입니다. 조회에는 일반적으로 이전 섹션에서 설명한
> 시나리오에서와 같이 프로토타입 bean이 포함됩니다. 스프링 프레임워크는 CHLIB 라이브러리의 바이트코드 생성을 사용하여 메서드를 재정의하는 서브클래스를 동적으로 생성함으로써 이 메서드 주입을 구현합니다:

<br>

- For this dynamic subclassing to work, the class that the Spring bean container subclasses cannot be final, and the
  method to be overridden cannot be final, either.
- Unit-testing a class that has an abstract method requires you to subclass the class yourself and to supply a stub
  implementation of the abstract method.
- Concrete methods are also necessary for component scanning, which requires concrete classes to pick up.
- A further key limitation is that lookup methods do not work with factory methods and in particular not with @Bean
  methods in configuration classes, since, in that case, the container is not in charge of creating the instance and
  therefore cannot create a runtime-generated subclass on the fly.
  {: .notice--primary}

> - 이 동적 하위 클래싱이 작동하려면, 스프링 빈 컨테이너 하위 클래스가 `final` 클래스가 될 수 없으며, 재정의할 메서드도 `final` 메서드가 될 수 없습니다.
> - `abstract` 메서드가 있는 클래스를 단위 테스트하려면 클래스를 직접 서브클래싱하고 `abstract` 메서드의 남은 부분 구현을 제공해야 합니다.
> - 컴포넌트 스캔에도 구체적인 메서드가 필요하며, 이를 위해서는 구체적인 클래스를 선택해야 합니다.
> - 또 다른 주요 제한 사항은 조회 메서드가 팩토리 메서드, 특히 구성 클래스의 `@Bean` 메서드에서는 작동하지 않는다는 것입니다. 이 경우, 컨테이너가 인스턴스 생성을 담당하지 않으므로 런타임에 생성된 하위
    클래스를 즉시 생성할 수 없기 때문입니다.

<br>

In the case of the CommandManager class in the previous code snippet, the Spring container dynamically overrides the
implementation of the createCommand() method. The CommandManager class does not have any Spring dependencies, as the
reworked example shows:

> 이전 코드의 `CommandManager` 클래스의 경우, 스프링 컨테이너가 `createCommand()` 메서드의 구현을 동적으로 재정의합니다. 재작업된 예제에서 볼 수 있듯이 `CommandManager`
> 클래스에는 스프링 의존성이 없습니다:

```java
package fiona.apple;

// no more Spring imports!
// 임포트 더 없음~

public abstract class CommandManager {

	public Object process(Object commandState) {
		// grab a new instance of the appropriate Command interface
		// 적절한 명령 인터페이스의 새 인스턴스를 가져옵니다
		Command command = createCommand();
		// set the state on the (hopefully brand new) Command instance
		// (새로운) Command 인스턴스에 상태를 설정합니다
		command.setState(commandState);
		return command.execute();
	}

	// okay... but where is the implementation of this method?
	// ㅇㅋ... 하지만 이 메서드의 구현은 어딨음?
	protected abstract Command createCommand();
}
```

<br>

In the client class that contains the method to be injected (the CommandManager in this case), the method to be injected
requires a signature of the following form:

> 주입할 메서드가 포함된 클래이언트 클래스( 이 경우 `CommandManager`)에서 구입할 메서드에는 아래와 같은 형식의 서명이 필요합니다:

```xml
<public|protected> [abstract] <return-type> theMethodName(no-arguments);
```

<br>

If the method is abstract, the dynamically-generated subclass implements the method. Otherwise, the
dynamically-generated subclass overrides the concrete method defined in the original class. Consider the following
example:

> 메서드가 `abstract`인 경우, 동적으로 생성된 하위 클래스가 메서드를 구현합니다. 그렇지 않으면, 동적으로 생성된 하위 클래스가 원래 클래스에 정의된 구체적인 메서드를 재정의합니다. 아래의 예제를
> 살펴보겠습니다:

```xml
<!-- a stateful bean deployed as a prototype (non-singleton) -->
<!-- 프로토타입으로 배포된 stateful `bean` (비싱글톤) -->
<bean id="myCommand" class="fiona.apple.AsyncCommand" scope="prototype">
	<!-- inject dependencies here as required -->
	<!-- 필요에 따라 여기에 의존성 주입 -->
</bean>

<!-- commandProcessor uses statefulCommandHelper -->
<bean id="commandManager" class="fiona.apple.CommandManager">
	<lookup-method name="createCommand" bean="myCommand"/>
</bean>
```

<br>

다음 이 시간에..

<br>

# Reference

- [Spring 공식 문서](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#spring-core)