from PyQt5.QtWidgets import QApplication, QMainWindow, QLabel 
import sys

class CustomTaskbar(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Custom Taskbar")
        self.setGeometry(0, 0, 800, 50)  # Set size and position

        # Create a label as a placeholder for taskbar buttons
        self.label = QLabel("This is a custom taskbar", self)
        self.label.setGeometry(10, 10, 200, 30)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = CustomTaskbar()
    window.show()
    sys.exit(app.exec_())
