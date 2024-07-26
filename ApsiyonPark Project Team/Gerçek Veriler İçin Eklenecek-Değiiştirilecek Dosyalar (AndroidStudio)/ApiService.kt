package com.example.apsiyon

import retrofit2.Call
import retrofit2.http.GET

interface ApiService {
    @GET("/")
    fun getParkingLayout(): Call<Array<Array<Int>>>
}
