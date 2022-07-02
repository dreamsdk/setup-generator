# Development sources for DreamSDK Setup

These files are fake, they are used only when you declare the following in your
`config.iss` file:

```
	#define SourceMode DEBUG
```

This will allow you to do some quick tests with **DreamSDK Setup**, avoiding
to wait to long by using the real files. In that way, you can test your updated
Setup really easily.

## About the `VERSION` file

Each time you change the `mingw/msys/1.0/opt/dreamsdk/VERSION` file from the
[system-objects repository](https://github.com/dreamsdk/system-objects/blob/master/mingw/msys/1.0/opt/dreamsdk/VERSION), 
you should copy your modified version in this repository, at the following location: `.sources-dev/system-objects/msys/1.0/opt/dreamsdk/VERSION`.

This will allow you to test the `SetPackageVersion` function from
[inc/helpers](https://github.com/dreamsdk/setup-generator/blob/master/src/inc/helpers.iss).
