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
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import com.google.android.material.navigation.NavigationView
import java.util.*

class MainActivity : AppCompatActivity() {

    private lateinit var gridView: GridView
    private lateinit var adapter: ParkingAdapter
    private val handler = Handler(Looper.getMainLooper())
    private val updateTask = object : Runnable {
        override fun run() {
            adapter.generateParkingData()
            adapter.notifyDataSetChanged()
            handler.postDelayed(this, 5000)
        }
    }

    private lateinit var drawerLayout: DrawerLayout
    private lateinit var navigationView: NavigationView
    private lateinit var toolbar: androidx.appcompat.widget.Toolbar

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        gridView = findViewById(R.id.gridView)
        adapter = ParkingAdapter()
        gridView.adapter = adapter

        drawerLayout = findViewById(R.id.drawerLayout)
        navigationView = findViewById(R.id.navigationView)
        toolbar = findViewById(R.id.toolbar)

        setSupportActionBar(toolbar)
        navigationView.setNavigationItemSelectedListener { menuItem ->
            handleNavigation(menuItem)
            true
        }

        val post = handler.post(updateTask)
    }

    private inner class ParkingAdapter : BaseAdapter() {

        private val parkingData = IntArray(121)

        init {
            generateParkingData()
        }

        fun generateParkingData() {
            val random = Random()
            for (i in parkingData.indices) {
                parkingData[i] = random.nextInt(2)
            }
            updateParkingPercentage()
        }

        private fun updateParkingPercentage() {
            val totalSpaces = parkingData.size
            val occupiedSpaces = parkingData.count { it == 1 }
            val percentage = (occupiedSpaces.toFloat() / totalSpaces) * 100
            supportActionBar?.title = "Otopark Boş Alan: %.1f%%".format(100 - percentage)
        }

        override fun getCount(): Int {
            return parkingData.size
        }

        override fun getItem(position: Int): Any {
            return parkingData[position]
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

            if (parkingData[position] == 0) {
                imageView.setBackgroundColor(Color.GREEN)
            } else {
                imageView.setBackgroundColor(Color.RED)
            }

            return imageView
        }
    }

    private fun handleNavigation(menuItem: MenuItem) {
        when (menuItem.itemId) {
            R.id.nav_settings -> {

            }
            R.id.nav_building -> {

            }
            R.id.nav_dues -> {

            }
            R.id.nav_gym -> {

            }
            R.id.nav_parking -> {

            }
            R.id.nav_logout -> {
                finishAffinity()
            }
        }
        drawerLayout.closeDrawer(GravityCompat.START)
    }
}
