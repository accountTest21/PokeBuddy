# PokeBuddy

PokeBuddy is an app that display a Pokemon list and Pokemon informations.

## Table of contents
* [Technologies](#technologies)
* [General info](#general-info)

## Tenchologies

- Swift 4+
- Core Data

## General info
The project is a simple Pokemon viewer with [Pokemon List](#pokemon-list) and [Pokemon Detail](#pokemon-detail) write using MVVM architecture. 



### Pokemon List

Composed by UITableView that display information retrieved from database or service.

A **paging** system was used to make the application faster. 

**Caching** mechanism has been implemented to retrieve the images and avoid downloading them every time. Also with database downloaded data it is always available also **offline**.

### Pokemon Detail

It's a simple view controller that display Pokemon information. Information are arranged in a vertical Stack View.

I chose to use a stack view because there are few elements to show.

Application Works in portrait and landscape mode
