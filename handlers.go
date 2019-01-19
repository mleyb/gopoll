package main

import (
	"database/sql"
	"net/http"
	"strconv"
	"github.com/labstack/echo"
)

type H map[string]interface{}

func GetPolls(db *sql.DB) echo.HandlerFunc {
	return func(c echo.Context) error {
		return c.JSON(http.StatusOK, GetPollsFromDb(db))
	}
}

func UpdatePoll(db *sql.DB) echo.HandlerFunc {
	return func(c echo.Context) error {
		var poll Poll

		c.Bind(&poll)

		index, _ := strconv.Atoi(c.Param("index"))

		id, err := UpdatePollInDb(db, index, poll.Name, poll.Upvotes, poll.Downvotes)

		if err == nil {
			return c.JSON(http.StatusCreated, H{
				"affected": id,
			})
		}

		return err
	}
}