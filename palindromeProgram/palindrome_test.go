package palindromeProgram

import (
	"strconv"
	"testing"
)

func Test_Palindrome(t *testing.T) {
	testStrings := []string{"apple", "racecar", "palindrome", "radar", "level", "house"}
	expectedOutput := []bool{false, true, false, true, true, false}

	for i, testString := range testStrings {
		output := isPalindrome(testString)
		if output != expectedOutput[i] {
			t.Fatalf("Incorrect output %s, expected isPalindrome output for %s is %s", strconv.FormatBool(output), testString, strconv.FormatBool(expectedOutput[i]))
		}
	}
}
