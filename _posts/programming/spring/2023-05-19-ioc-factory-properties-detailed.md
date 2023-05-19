---
title: "[Spring] IoC 컨테이너 공식문서 번역 (Dependencies and Configuration in Detail)"
excerpt: "의존성 및 구성 상세 정보"

categories:
  - Spring
tags:
  - [ioc]

toc: true
toc_sticky: true

date: 2023-05-19
last_modified_at: 2023-05-19
---

> 현재 [매일 공식 문서를 읽고 해석하는 챌린지](https://github.com/yeonise/daily-code-snippets)를 진행 중이며, 일주일 단위로 정리해 나가고 있습니다.

<br>

# 기록

- [IoC 컨테이너 공식문서 번역 (Introduction to the Spring IoC Container and Beans)](https://sully-tech.dev/spring/ioc-introduction/)
- [IoC 컨테이너 공식문서 번역 (Container Overview)](https://sully-tech.dev/spring/ioc-basics/)
- [IoC 컨테이너 공식문서 번역 (Bean OverView)](https://sully-tech.dev/spring/ioc-definition/)
- [IoC 컨테이너 공식문서 번역 (Dependencies and Configuration in Detail)](https://sully-tech.dev/spring/ioc-dependencies/)

<br>

# Dependencies and Configuration in Detail

As mentioned in the previous section, you can define bean properties and constructor arguments as references to other
managed beans (collaborators) or as values defined inline. Spring’s XML-based configuration metadata supports
sub-element types within its <property/> and <constructor-arg/> elements for this purpose.

> 이전 섹션에서 언급했듯이, 빈 프로퍼티와 생성자 인자를 다른 관리되는 빈(콜라보레이터)에 대한 참조로 정의하거나 인라인으로 정의된 값을 정의할 수 있습니다. 스프링의 XML 기반 구성 메타데이터는 이러한 목적을
> 위해 `<property/>` 및 `<constructor-arg/>` 요소 내에서 하위 요소 유형을 지원합니다.

<br>

## Straight Values (Primitives, Strings, and so on)

The value attribute of the <property/> element specifies a property or constructor argument as a human-readable string
representation. Spring’s conversion service is used to convert these values from a String to the actual type of the
property or argument. The following example shows various values being set:

> `<property/>` 요소의 값 속성은 프로퍼티 또는 생성자 인자를 사람이 읽을 수 있는 문자열 표현으로 지정합니다. 스프링의 변환 서비스는 이러한 값을 `String`에서 프로퍼티 또는 인자의 실제 유형으로
> 반환되는 데 사용됩니다. 아래의 예제는 다양한 값이 설정되는 것을 보여줍니다:

```xml
<bean id="myDataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
	<!-- results in a setDriverClassName(String) call -->
	<property name="driverClassName" value="com.mysql.jdbc.Driver"/>
	<property name="url" value="jdbc:mysql://localhost:3306/mydb"/>
	<property name="username" value="root"/>
	<property name="password" value="misterkaoli"/>
</bean>
```

<br>

The following example uses the p-namespace for even more succinct XML configuration:

> 아래의 예제에서는 더욱 간결한 XML 구성을 위해 `p-namesapce`를 사용합니다:

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.springframework.org/schema/p"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	https://www.springframework.org/schema/beans/spring-beans.xsd">

	<bean id="myDataSource" class="org.apache.commons.dbcp.BasicDataSource"
		destroy-method="close"
		p:driverClassName="com.mysql.jdbc.Driver"
		p:url="jdbc:mysql://localhost:3306/mydb"
		p:username="root"
		p:password="misterkaoli"/>

</beans>
```

The preceding XML is more succinct. However, typos are discovered at runtime rather than design time, unless you use an
IDE (such as IntelliJ IDEA or the Spring Tools for Eclipse) that supports automatic property completion when you create
bean definitions. Such IDE assistance is highly recommended.

> 앞의 XML이 더 간결합니다. 그러나 빈 정의를 생성할 때 자동 속성 완성을 지원하는 IDE를 사용하지 않는 한 오타가 설계 시점이 아닌, 런타임에 발견됩니다. 이러한 IDE 지원을 적극 권장합니다. 알겠습니다!

<br>

You can also configure a java.util.Properties instance, as follows:

> 다음과 같이 `java.util.Preperties` 인스턴스를 구성할 수도 있습니다:

```xml
<bean id="mappings"
	class="org.springframework.context.support.PropertySourcesPlaceholderConfigurer">

	<!-- typed as a java.util.Properties -->
	<property name="properties">
		<value>
			jdbc.driver.className=com.mysql.jdbc.Driver
			jdbc.url=jdbc:mysql://localhost:3306/mydb
		</value>
	</property>
</bean>
```

The Spring container converts the text inside the <value/> element into a java.util.Properties instance by using the
JavaBeans PropertyEditor mechanism. This is a nice shortcut, and is one of a few places where the Spring team do favor
the use of the nested <value/> element over the value attribute style.

> 스프링 컨테이너는 JavaBeans `PrepertiyEditor` 메커니즘을 사용하여 `<values>` 요소 내부의 텍스트를 `java.util.Properties` 인스턴스로 변환합니다. 이것은 좋은
> 지름길이며, 스프링 팀에서 값 속성 스타일보다 중첩된 `<value/>` 요소의 사용을 선호하는 몇 안 되는 곳 중 하나입니다.

<br>

### The idref element

The idref element is simply an error-proof way to pass the id (a string value - not a reference) of another bean in the
container to a <constructor-arg/> or <property/> element. The following example shows how to use it:

> `idref` 요소는 컨테이너에 있는 다른 빈의 `id`(참조가 아닌 문자열 값)를 `<constructor-arg/>` 또는 `<property/>` 요소로 전달하는 오류 방지 방식입니다. 아래의 예제는 그
> 사용 방법을 보여줍니다:

```xml
<bean id="theTargetBean" class="..."/>

<bean id="theClientBean" class="...">
	<property name="targetName">
		<idref bean="theTargetBean"/>
	</property>
</bean>
```

The preceding bean definition snippet is exactly equivalent (at runtime) to the following snippet:

> 위의 빈 정의 코드는 (실행 시) 아래의 코드와 정확히 동일합니다:

```xml
<bean id="theTargetBean" class="..." />

<bean id="client" class="...">
	<property name="targetName" value="theTargetBean"/>
</bean>
```

The first form is preferable to the second, because using the idref tag lets the container validate at deployment time
that the referenced, named bean actually exists. In the second variation, no validation is performed on the value that
is passed to the targetName property of the client bean. Typos are only discovered (with most likely fatal results) when
the client bean is actually instantiated. If the client bean is a prototype bean, this typo and the resulting exception
may only be discovered long after the container is deployed.

> 첫 번째 형태가 두 번째 형태보다 더 선호되는데, 이는 `idref` 태그를 사용하면 컨테이너가 배포 시점에 참조된 빈이 실제로 존재하는지 확인할 수 있기 때문입니다. 두 번째 변형에서는 `client`
> 빈의 `targetName` 속성에 전달되는 값에 대한 유효성 검사가 수행되지 않습니다. 오타는 `client` 빈이 실제로 인스턴스화될 때만 발견됩니다(대부분 치명적인 결과를 초래할 수 있음). 클라이언트 빈이
> 프로토타입 빈일 경우, 이 오타와 그에 따른 예외는 컨테이너가 배포된 후 한참 후에야 발견될 수 있습니다.

<br>

The local attribute on the idref element is no longer supported in the 4.0 beans XSD, since it does not provide value
over a regular bean reference any more. Change your existing idref local references to idref bean when upgrading to the
4.0 schema.
{: .notice--primary}

> `idref` 요소의 `local` 속성은 더 이상 일반 빈 참조에 대한 값을 제공하지 않으므로, 4.0 빈 XSD에서 더 이상 지원되지 않습니다. 4.0 스키마로 업그레이드할 때, 기존 `idref local`
> 참조를 `idref bean` 빈으로 변경하세요.

<br>

A common place (at least in versions earlier than Spring 2.0) where the <idref/> element brings value is in the
configuration of AOP interceptors in a ProxyFactoryBean bean definition. Using <idref/> elements when you specify the
interceptor names prevents you from misspelling an interceptor ID.

> `<idref/>` 요소가 가치를 제공하는 일반적인 위치(적어도 스프링 2.0 이전 버전)는 `ProxyFactoryBean` 빈 정의의 AOP 인터셉터 구성입니다. 인터셉터 이름을 지정할
> 때, `<idref/>` 요소를 사용하면 인터셉터 ID의 철자를 잘못 입력하는 것을 방지할 수 있습니다.

<br>

## References to Other Beans (Collaborators)

The ref element is the final element inside a <constructor-arg/> or <property/> definition element. Here, you set the
value of the specified property of a bean to be a reference to another bean (a collaborator) managed by the container.
The referenced bean is a dependency of the bean whose property is to be set, and it is initialized on demand as needed
before the property is set. (If the collaborator is a singleton bean, it may already be initialized by the container.)
All references are ultimately a reference to another object. Scoping and validation depend on whether you specify the ID
or name of the other object through the bean or parent attribute.

> `ref` 요소는 `<constructor-arg/>` 또는 `<property/>` 정의 요소 내부의 마지막 요소입니다. 여기에서는, 빈의 지정된 속성 값을 컨테이너에서 관리하는 다른 빈(콜라보레이터)에 대한
> 참조로 설정합니다. 참조된 빈은 속성을 설정하려는 빈의 의존성이며, 속성이 설정되기 전에 필요에 따라 초기화됩니다. (콜라보레이터가 싱글톤 빈인 경우, 컨테이너에 의해 이미 초기화되었을 수 있습니다.) 모든
> 참조는
> 궁극적으로 다른 객체에 대한 참조입니다. 범위 지정 및 유효성 검사는 `bean` 또는 `parent` 속성을 통해 다른 객체의 ID 또는 이름을 지정하는지의 여부에 따라 달라집니다.

Specifying the target bean through the bean attribute of the <ref/> tag is the most general form and allows creation of
a reference to any bean in the same container or parent container, regardless of whether it is in the same XML file. The
value of the bean attribute may be the same as the id attribute of the target bean or be the same as one of the values
in the name attribute of the target bean. The following example shows how to use a ref element:

> `<ref/>` 태그의 빈 속성을 통해 대상 빈을 지정하는 것이 가장 일반적인 형식이며, 동일한 XML 파일에 있는지의 여부에 관계없이 동일한 컨테이너 또는 상위 컨테이너에 있는 모든 빈에 대한 참조를 생성할 수
> 있습니다. 빈 속성의 값은 대상 빈의 `id` 속성과 동일하거나 대상 빈의 `name` 속성에 있는 값 중 하나와 동일할 수 있습니다. 아래의 예는 `ref` 요소를 사용하는 방법을 보여줍니다:

```xml
<ref bean="someBean"/>
```

<br>

Specifying the target bean through the parent attribute creates a reference to a bean that is in a parent container of
the current container. The value of the parent attribute may be the same as either the id attribute of the target bean
or one of the values in the name attribute of the target bean. The target bean must be in a parent container of the
current one. You should use this bean reference variant mainly when you have a hierarchy of containers and you want to
wrap an existing bean in a parent container with a proxy that has the same name as the parent bean. The following pair
of listings shows how to use the parent attribute:

> `parent` 속성을 통해 대상 빈을 지정하면, 현재 컨테이너의 상위 컨테이너에 있는 빈에 대한 참조가 생성됩니다. `parent` 속성의 값은 대상 빈의 id 속성 또는 대상 빈의 `name` 속성에 있는 값
> 중 하나와 동일할 수 있습니다. 대상 빈은 현재 컨테이너의 상위 컨테이너에 있어야 합니다. 이 빈의 참조 변형은 주로 컨테이너 계층 구조가 있고 부모 빈과 이름이 같은 프록시를 사용하여 기존 빈을 부모 컨테이너에
> 래핑하려는 경우에 사용해야 합니다. 아래의 목록은 `parent` 속성을 사용하는 방법을 보여줍니다:

```xml
<!-- in the parent context -->
<bean id="accountService" class="com.something.SimpleAccountService">
	<!-- insert dependencies as required here -->
</bean>
```

```xml
<!-- in the child (descendant) context -->
<bean id="accountService" <!-- bean name is the same as the parent bean -->
	class="org.springframework.aop.framework.ProxyFactoryBean">
	<property name="target">
		<ref parent="accountService"/> <!-- notice how we refer to the parent bean -->
	</property>
	<!-- insert other configuration and dependencies as required here -->
</bean>
```

<br>

The local attribute on the ref element is no longer supported in the 4.0 beans XSD, since it does not provide value over
a regular bean reference any more. Change your existing ref local references to ref bean when upgrading to the 4.0
schema.
{: .notice--primary}

> `ref` 요소의 `local` 속성은 더 이상 일반 `bean` 참조에 대한 값을 제공하지 않으므로, 4.0 bean XSD에서 더 이상 지원되지 않습니다. 4.0 스키마로 업그레이드할 때,
> 기존 `ref local` 참조를 `ref bean`으로 변경하세요. 

<br>

## Inner Beans

추가 예정...

<br>

# Reference

- [Spring 공식 문서](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#spring-core)