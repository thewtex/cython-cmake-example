import sys

from rect import Rectangle

def main(x0, y0, x1, y1):
    rect = Rectangle(int(x0), int(y0), int(x1), int(y1))
    msg = 'For the rectangle with corners located at ('
    msg += str(x0) + ', ' + str(y0) + ') and ('
    msg += str(x1) + ', ' + str(y1) + '):\n'
    print(msg)
    msg = 'The length is ' + str(rect.getLength())
    msg += ' and the height is ' + str(rect.getHeight()) + '.'
    print(msg)
    msg = 'The area is ' + str(rect.getArea()) + '.'
    print(msg)

if __name__ == '__main__':
    usage = sys.argv[0] + ' x0 y0 x1 y1'
    if len(sys.argv) < 5:
        print(usage)
        sys.exit(1)

    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
