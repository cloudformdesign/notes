// take user input to compute grades

#include <iomanip>
#include <ios>
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

// iomanip::
using std::setprecision;

// iostream::
using std::cin;
using std::cout;
using std::endl;

// string::
using std::string;

// ??
using std::streamsize;

// vector::
using std::vector;

// algorithm::
using std::sort;

int main() {
    cout << "Enter first name: ";
    string name;
    cin >> name;
    cout << "Hello, " << name << endl;

    // get midterm and final grades
    cout << "Please enter your midterm and final grades: ";
    double mid, fin;
    cin >> mid >> fin;

    // ask for homework grades
    cout << "Enter homework grades, followed by EOF: ";
    vector<double> homework;
    double x; // value to read into

    // invarant: we have read `count` grades so far, sum is their sum.
    // note: instance `cin` can evaluate to an integer, which gets converted into a bool
    // The value is based on the last-read value.
    // Object Oriented for-the-win yes?
    while (cin >> x) {
        homework.push_back(x);
    }

    // I get the feeling that `size_type` changes depending on the size of the
    // item in vector... incredible -- I never even considered that.
    typedef vector<double>::size_type vec_sz;
    vec_sz size = homework.size();

    if (0 == size) {
        cout << endl << "You must enter at least one grade" << endl;
        return 1;
    }

    sort(homework.begin(), homework.end());

    // wow... this has be the the most foot-shootie thing I have ever seen...
    // you can literally do this:
    //     vector<double> testing;
    //     testing.push_back(2.3);
    //     sort(homework.begin(), testing.end());

    const vec_sz i = size / 2;
    const double median =
        size % 2 == 0 ?
        homework[i] + homework[i - 1] / 2 // invarant: smallest size == 1
        : homework[i];
    // write the result
    streamsize prec = cout.precision();
    cout << "Your final grade is "
        << setprecision(3)
        << 0.2 * mid + 0.4 * fin + 0.4 * median
        << setprecision(prec)
        << endl;
    return 0;
}
