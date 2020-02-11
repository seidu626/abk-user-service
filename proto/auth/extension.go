package auth

import (
	"github.com/satori/go.uuid"
	"github.com/jinzhu/gorm"
)

// @TODO: not working for v1.13 github.com/satori/go.uuid

func (model *User) BeforeCreate(scope *gorm.Scope) error {
	uuid := uuid.NewV4()
	// if err != nil {
	// 	return err
	// }
	return scope.SetColumn("Id", uuid.String())
}
