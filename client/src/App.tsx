import './App.css'
import { UserProvider } from './contexts/UserContext'
import AddUser from './components/AddUser'
import UserList from './components/UserList'

function App() {
  return (
    <UserProvider>
      <div>
        <h1>User Management</h1>
        <AddUser />
        <UserList />
      </div>
    </UserProvider>
  )
}

export default App
