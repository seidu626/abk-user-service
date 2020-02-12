package auth

import (
	"github.com/jinzhu/gorm"
	"github.com/satori/go.uuid"
)

// @TODO: not working for v1.13 github.com/satori/go.uuid

func (model *User) BeforeCreate(scope *gorm.Scope) error {
	uuid := uuid.NewV4()
	// if err != nil {
	// 	return err
	// }
	return scope.SetColumn("Id", uuid.String())
}
