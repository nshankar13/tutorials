package palindromeProgram

import (
	"fmt"
	"os"
	"strconv"
)

func isPalindrome(s string) bool {
	slength := len(s)
	for i := 0; i < slength/2; i++ {
		j := slength - 1 - i
		if s[i] != s[j] {
			return false
		}
	}
	return true
}

func main() {
	word := os.Args[1]
	isPalindrome := isPalindrome(word)

	fmt.Printf("%s\n", strconv.FormatBool(isPalindrome))
}
