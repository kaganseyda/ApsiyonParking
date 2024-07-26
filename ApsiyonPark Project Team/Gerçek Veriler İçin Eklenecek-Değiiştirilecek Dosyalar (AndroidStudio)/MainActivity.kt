package com.example.apsiyon

import android.graphics.Color
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.AbsListView
import android.widget.BaseAdapter
import android.widget.GridView
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import com.google.android.material.navigation.NavigationView
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MainActivity : AppCompatActivity() {

    private lateinit var gridView: GridView
    private lateinit var adapter: ParkingAdapter
    private lateinit var parkingPercentage: TextView
    private val handler = Handler(Looper.getMainLooper())
    private val updateTask = object : Runnable {
        override fun run() {
            fetchParkingLayout()
            handler.postDelayed(this, 5000)
        }
    }

    private lateinit var drawerLayout: DrawerLayout
    private lateinit var navigationView: NavigationView
    private lateinit var toolbar: Toolbar

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        gridView = findViewById(R.id.gridView)
        adapter = ParkingAdapter()
        gridView.adapter = adapter

        parkingPercentage = findViewById(R.id.parkingPercentage)

        drawerLayout = findViewById(R.id.drawerLayout)
        navigationView = findViewById(R.id.navigationView)
        toolbar = findViewById(R.id.toolbar)

        setSupportActionBar(toolbar)
        navigationView.setNavigationItemSelectedListener { menuItem ->
            handleNavigation(menuItem)
            true
        }

        handler.post(updateTask)
    }

    private fun fetchParkingLayout() {
        val retrofit = RetrofitClient.getClient("http://your_flask_server_url/")
        val apiService = retrofit.create(ApiService::class.java)
        val call = apiService.getParkingLayout()

        call.enqueue(object : Callback<Array<Array<Int>>> {
            override fun onResponse(
                call: Call<Array<Array<Int>>>,
                response: Response<Array<Array<Int>>>
            ) {
                if (response.isSuccessful) {
                    val parkingLayout = response.body() ?: return
                    adapter.updateParkingData(parkingLayout)
                    updateParkingPercentage(parkingLayout)
                }
            }

            override fun onFailure(call: Call<Array<Array<Int>>>, t: Throwable) {
                // Handle failure
            }
        })
    }

    private fun updateParkingPercentage(parkingLayout: Array<Array<Int>>) {
        val totalCells = parkingLayout.size * parkingLayout[0].size
        val occupiedCells = parkingLayout.flatten().count { it == 1 }
        val percentage = (occupiedCells.toDouble() / totalCells * 100).toInt()
        parkingPercentage.text = "Boş Alan: %$percentage"
    }

    private inner class ParkingAdapter : BaseAdapter() {

        private var parkingData: Array<Array<Int>> = Array(10) { Array(10) { 0 } }

        fun updateParkingData(newData: Array<Array<Int>>) {
            parkingData = newData
            notifyDataSetChanged()
        }

        override fun getCount(): Int {
            return parkingData.size * parkingData[0].size
        }

        override fun getItem(position: Int): Any {
            val row = position / parkingData[0].size
            val col = position % parkingData[0].size
            return parkingData[row][col]
        }

        override fun getItemId(position: Int): Long {
            return position.toLong()
        }

        override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
            val imageView: ImageView
            if (convertView == null) {
                imageView = ImageView(this@MainActivity)
                imageView.layoutParams = AbsListView.LayoutParams(130, 85)
                imageView.scaleType = ImageView.ScaleType.CENTER_CROP
            } else {
                imageView = convertView as ImageView
            }

            val row = position / parkingData[0].size
            val col = position % parkingData[0].size
            val value = parkingData[row][col]

            imageView.setBackgroundColor(if (value == 0) Color.GREEN else Color.RED)

            return imageView
        }
    }

    private fun handleNavigation(menuItem: MenuItem) {
        when (menuItem.itemId) {
            R.id.nav_settings -> {
                // Ayarlar tıklama işlemi
            }
            R.id.nav_building -> {
                // Binam tıklama işlemi
            }
            R.id.nav_dues -> {
                // Aidatlarım tıklama işlemi
            }
            R.id.nav_gym -> {
                // Spor Salonu tıklama işlemi
            }
            R.id.nav_parking -> {
                // Otopark tıklama işlemi
                // Otopark Ne Durumda? ekranına yönlendirme
            }
            R.id.nav_logout -> {
                finishAffinity() // Uygulamayı kapat
            }
        }
        drawerLayout.closeDrawer(GravityCompat.START)
    }
}
