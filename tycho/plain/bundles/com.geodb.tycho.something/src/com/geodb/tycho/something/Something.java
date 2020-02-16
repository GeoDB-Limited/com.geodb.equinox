package com.geodb.tycho.something;

public class Something {
	private static Something instance = null;

	private Something() {
		super();
	}

	public static Something getInstance() {
		if (instance == null) {
			instance = new Something();
		}

		return instance;
	}

	public void sayHello() {
		System.out.println("Hello");
	}
}
