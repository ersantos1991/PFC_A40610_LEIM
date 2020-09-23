package com.a40610.appannotation.background.ble.decode

interface Decode {

    fun getData(): MutableMap<String, Any>

    fun getName(): String

    override fun toString():String

}